//
//  HomeFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/26.
//

import Foundation
import SwiftUI

import ComposableArchitecture
import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate

enum MeetingStatus {
    case ready // 약속 전날까지
    case progress // 약속 당일
    case confirmed // 약속 당일 + 약속 1시간 전
    case completed // 지난 약속

    var title: String {
        switch self {
        case .ready, .progress, .confirmed: return "예정된 약속"
        case .completed: return "지난 약속"
        }
    }

    var fgColor: Color {
        switch self {
        case .ready, .completed, .confirmed: return .gray.opacity(0.5)
        case .progress: return .pink
        }
    }
}

struct HomeFeature: ReducerProtocol {

    @Environment(\.openURL) private var openURL

    struct State: Equatable {
        // MARK: - Scope State

        // 예정된 약속(progress), 지난 약속(completed)
        var meetingStatus: MeetingStatus = .progress
        var meetingDetailId: Int?
        var pushMeetingDetail: Bool = false

        var progressList: [Meeting] = []
        var completedList: [Meeting] = []
        var meetingDetailState: MeetingDetailFeature.State = MeetingDetailFeature.State(
            meetingId: 0)
        var isRefreshing: Bool = false

        @PresentationState var usingCamera: CameraFeature.State?
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case fetchMeetingList(MeetingStatus)
        case updateMeetingList(MeetingStatus, [Meeting]?)
        case refreshMeetingList
        case changeMeetingStatus(MeetingStatus)

        // 카카오톡 공유

        case shareButtonTapped
        case invitationSuccess
        case invitationFailed

        // 모임 상세

        case meetingDetailAction(MeetingDetailFeature.Action)
        case pushToMeetingDetail(Int)
        case pushMeetingDetail

        case cameraButtonTapped
        case usingCamera(PresentationAction<CameraFeature.Action>)
    }

    @Dependency(\.sendInvitation) private var sendInvitation
    @Dependency(\.meetingService) var meetingService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.meetingDetailState, action: /Action.meetingDetailAction) {
            MeetingDetailFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .onAppear:
                if state.progressList.isEmpty && state.completedList.isEmpty {
                    return .run { send in
                        await send(.fetchMeetingList(.progress))
                    }
                } else {
                    return .none
                }

            case .fetchMeetingList(let status):
                state.meetingStatus = status
                return .run { send in
                    let list = await meetingService.fetchMeetingList(status)
                    await send(.updateMeetingList(status, list))
                }

            case .refreshMeetingList:
                state.isRefreshing = true
                state.progressList.removeAll()
                state.completedList.removeAll()
                state.meetingStatus = .progress
                return .run { send in
                    do {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        let list = await meetingService.fetchMeetingList(.progress)
                        await send(.updateMeetingList(.progress, list))
                    } catch {
                        print("error")
                    }
                }

            case .changeMeetingStatus(let status):
                state.meetingStatus = status
                if status == .completed && state.completedList.isEmpty {
                    return .run { send in
                        await send(.fetchMeetingList(.completed))
                    }
                }
                return .none

            case .updateMeetingList(let type, let model):
                if let model {
                    if type == .progress {
                        state.progressList.append(contentsOf: model)
                    } else {
                        state.completedList.append(contentsOf: model)
                    }
                }
                state.isRefreshing = false
                return .none

            case .shareButtonTapped:
                return .run { send in
                    if ShareApi.isKakaoTalkSharingAvailable() {
                        if let url = await sendInvitation(name: "집들이집들", id: 1000) {
                            openURL(url)
                            await send(.invitationSuccess)
                        } else {
                            await send(.invitationFailed)
                        }
                    } else {
                        moveToAppStore()
                    }
                }

            case .invitationSuccess:
                print("초대하기 성공")
                return .none

            case .invitationFailed:
                print("초대하기 실패")
                return .none

            case .pushToMeetingDetail(let id):
                state.meetingDetailId = id
                state.meetingDetailState = MeetingDetailFeature.State(meetingId: id)
                return .run { send in
                    await send(.pushMeetingDetail)
                }

            case .pushMeetingDetail:
                state.pushMeetingDetail = true
                return .none

            case .meetingDetailAction(.delegate(.onDisappear)):
                state.pushMeetingDetail = false
                state.meetingDetailId = nil
                return .none

            case .meetingDetailAction(.delegate(.deleteSuccess)):
                return .run { send in
                    await send(.refreshMeetingList)
                }

            case .meetingDetailAction:
                return .none

            case .cameraButtonTapped:
                state.usingCamera = CameraFeature.State()
                return .none

            case .usingCamera:
                return .none
            }

            @Sendable func moveToAppStore() {
                let url = "itms-apps://itunes.apple.com/app/362057947"
                if let url = URL(string: url) {
                    openURL(url)
                }
            }
        }
        .ifLet(\.$usingCamera, action: /Action.usingCamera) {
            CameraFeature()
        }
    }
}
