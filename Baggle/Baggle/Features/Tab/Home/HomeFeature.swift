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

struct HomeFeature: ReducerProtocol {

    struct State: Equatable {

        var user: User = UserDefaultList.user ?? User.mockUp()
        var homeStatus: HomeStatus = .empty
        
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
        case changeHomeStatus(HomeStatus)
        case fetchMeetingList(MeetingStatus)
        case updateMeetingList(MeetingStatus, [Meeting]?)
        case refreshMeetingList
        case changeMeetingStatus(MeetingStatus)

        // 모임 상세

        case meetingDetailAction(MeetingDetailFeature.Action)
        case pushToMeetingDetail(Int)
        case pushMeetingDetail

        case cameraButtonTapped
        case usingCamera(PresentationAction<CameraFeature.Action>)
    }

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

            case .changeHomeStatus(let status):
                state.homeStatus = status
                return .none

            case .fetchMeetingList(let status):
                state.meetingStatus = status
                return .run { send in
                    let list = await meetingService.fetchMeetingList(status)
                    await send(.updateMeetingList(status, list))
                }

            case .refreshMeetingList:
                state.isRefreshing = true
                state.homeStatus = .loading
                state.progressList.removeAll()
                state.completedList.removeAll()
                state.meetingStatus = .progress
                return .run { send in
                    do {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        let list = await meetingService.fetchMeetingList(.progress)
                        await send(.updateMeetingList(.progress, list))
                    } catch {
                        await send(.changeHomeStatus(.error))
                    }
                }

            case .changeMeetingStatus(let status):
                state.meetingStatus = status
                if status == .completed && state.completedList.isEmpty {
                    return .run { send in
                        await send(.fetchMeetingList(.completed))
                    }
                }

                if status == .progress && state.progressList.isEmpty {
                    return .run { send in await send(.fetchMeetingList(.progress))}
                }
                return .none

            case .updateMeetingList(let type, let model):
                if let model {
                    if type == .progress {
                        state.progressList.append(contentsOf: model)
                        state.homeStatus = state.progressList.isEmpty ? .empty : .normal
                    } else {
                        state.completedList.append(contentsOf: model)
                        state.homeStatus = state.completedList.isEmpty ? .empty : .normal
                    }
                }
                state.isRefreshing = false
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
        }
        .ifLet(\.$usingCamera, action: /Action.usingCamera) {
            CameraFeature()
        }
    }
}
