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
    case ongoing
    case dday
    case complete

    var title: String {
        switch self {
        case .ongoing, .dday: return "예정된 약속"
        case .complete: return "지난 약속"
        }
    }

    var fgColor: Color {
        switch self {
        case .ongoing, .complete: return .gray.opacity(0.5)
        case .dday: return .pink
        }
    }
}

struct HomeFeature: ReducerProtocol {

    @Environment(\.openURL) private var openURL

    struct State: Equatable {
        // MARK: - Scope State

        var meetingStatus: MeetingStatus = .ongoing
        var meetingDetailId: Int?
        var pushMeetingDetail: Bool = false

        var ongoingList: [Meeting] = []
        var completedList: [Meeting] = []
        var meetingDetailState: MeetingDetailFeature.State = MeetingDetailFeature.State(
            meetingId: 0)

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
                if state.ongoingList.isEmpty && state.completedList.isEmpty {
                    return .run { send in
                        await send(.fetchMeetingList(.ongoing))
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
                state.ongoingList.removeAll()
                state.completedList.removeAll()
                state.meetingStatus = .ongoing
                return .run { send in
                    let list = await meetingService.fetchMeetingList(.ongoing)
                    await send(.updateMeetingList(.ongoing, list))
                }

            case .changeMeetingStatus(let status):
                state.meetingStatus = status
                if status == .complete && state.completedList.isEmpty {
                    return .run { send in
                        await send(.fetchMeetingList(.complete))
                    }
                }
                return .none

            case .updateMeetingList(let type, let model):
                if let model {
                    if type == .ongoing {
                        state.ongoingList.append(contentsOf: model)
                    } else {
                        state.completedList.append(contentsOf: model)
                    }
                }
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
