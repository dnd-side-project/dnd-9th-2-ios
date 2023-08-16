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

        var progressCount: Int = 0
        var completedCount: Int = 0
        var progressList: [Meeting] = []
        var completedList: [Meeting] = []
        var meetingDetailState = MeetingDetailFeature.State(
            meetingId: Const.ErrorID.meeting
        )
        var isRefreshing: Bool = false

        @PresentationState var usingCamera: CameraFeature.State?
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case changeHomeStatus(HomeStatus)
        case fetchMeetingList(MeetingStatus)
        case updateMeetingList(MeetingStatus, Home)
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

                // 데이터 요청 후 뷰 상태 변경
            case .changeHomeStatus(let status):
                state.homeStatus = status
                return .none

                // 데이터 요청
            case .fetchMeetingList(let status):
                state.meetingStatus = status
                return .run { send in
                    // TODO: - page
                    let result = await meetingService.fetchMeetingList(status, 0)
                    switch result {
                    case .success(let data):
                        await send(.updateMeetingList(status, data))
                    case .fail:
                        await send(.changeHomeStatus(.error))
                    }
                }

                // 초기화
            case .refreshMeetingList:
                state.isRefreshing = true
                state.homeStatus = .loading
                state.progressList.removeAll()
                state.completedList.removeAll()
                state.meetingStatus = .progress
                return .run { send in
                    do {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        let result = await meetingService.fetchMeetingList(.progress, 0)
                        switch result {
                        case .success(let data):
                            await send(.updateMeetingList(.progress, data))
                        case .fail:
                            await send(.changeHomeStatus(.error))
                        }
                    } catch {
                        await send(.changeHomeStatus(.error))
                    }
                }

                // segmentControl 변경
                // 기존 데이터 없는 경우에 데이터 요청, 아니면 요청 X
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

                // 데이터 업데이트
            case .updateMeetingList(let type, let model):
                state.progressCount = model.progressCount
                state.completedCount = model.completedCount
                if let meetings = model.meetings {
                    if type == .progress {
                        state.progressList.append(contentsOf: meetings)
                        state.homeStatus = state.progressList.isEmpty ? .empty : .normal
                    } else {
                        state.completedList.append(contentsOf: meetings)
                        state.homeStatus = state.completedList.isEmpty ? .empty : .normal
                    }
                }
                state.isRefreshing = false
                return .none

            case .pushToMeetingDetail(let id):
                state.meetingDetailId = id
                state.meetingDetailState = MeetingDetailFeature.State(
                    meetingId: id
                )
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
                state.usingCamera = CameraFeature.State(
                    timer: TimerFeature.State(timerCount: 30)
                )
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
