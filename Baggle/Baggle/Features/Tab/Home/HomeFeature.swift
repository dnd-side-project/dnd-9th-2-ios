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

        var user: User = UserManager.shared.user ?? User.error()
        var homeStatus: HomeStatus = .empty
        
        // 예정된 약속(progress), 지난 약속(completed)
        var meetingStatus: MeetingStatus = .progress
        var progressCount: Int = 0
        var completedCount: Int = 0
        var progressList: [Meeting] = []
        var completedList: [Meeting] = []
        
        // 무한스크롤
        var size: Int = 5
        var progressIndex: Int = 0
        var completedIndex: Int = 0
        var requestedProgressIndex: Set<Int> = []
        var requestedCompletedIndex: Set<Int> = []
        
        // 모임 상세
        var meetingDetailId: Int?
        var pushMeetingDetail: Bool = false
        var meetingDetailState = MeetingDetailFeature.State(
            meetingId: Const.ErrorID.meeting
        )
        
        // 초기화
        var isRefreshing: Bool = false

        @PresentationState var usingCamera: CameraFeature.State?
        @PresentationState var usingEmergency: EmergencyFeature.State?
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case scrollReachEnd(Int)
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
        
        case emergencyButtonTapped
        case usingEmergency(PresentationAction<EmergencyFeature.Action>)
        
        // Delegate
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case moveToLogin
        }
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
                state.user = UserManager.shared.user ?? User.error()
                if state.progressList.isEmpty && state.completedList.isEmpty {
                    return .run { send in
                        await send(.fetchMeetingList(.progress))
                    }
                } else {
                    return .none
                }
                
                // 스크롤 끝에 닿은 경우 데이터 요청
            case .scrollReachEnd(let index):
                // meetingStatus에 따라 fetchMeetingList 요청
                let status = state.meetingStatus
                if status == .progress {
                    if state.requestedProgressIndex.contains(index) {
                        return .none
                    } else {
                        state.requestedProgressIndex.insert(index)
                    }
                } else {
                    if state.requestedCompletedIndex.contains(index) {
                        return .none
                    } else {
                        state.requestedCompletedIndex.insert(index)
                    }
                }
                return .run { send in await send(.fetchMeetingList(status))}

                // 데이터 요청 후 뷰 상태 변경
            case .changeHomeStatus(let status):
                state.homeStatus = status
                state.isRefreshing = false
                return .none

                // 데이터 요청
            case .fetchMeetingList(let status):
                state.meetingStatus = status
                let page = (status == .progress) ? state.progressIndex : state.completedIndex
                let requestModel = HomeRequestModel(status: status, page: page, size: state.size)
                return .run { send in
                    let result = await meetingService.fetchMeetingList(requestModel)
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
                state.meetingStatus = .progress
                state.progressIndex = 0
                state.completedIndex = 0
                state.progressList.removeAll()
                state.completedList.removeAll()
                state.requestedProgressIndex.removeAll()
                state.requestedCompletedIndex.removeAll()
                let requestModel = HomeRequestModel(status: .progress, page: 0, size: state.size)
                return .run { send in
                    let result = await meetingService.fetchMeetingList(requestModel)
                    switch result {
                    case .success(let data):
                        await send(.updateMeetingList(.progress, data))
                    case .fail:
                        await send(.changeHomeStatus(.error))
                    }
                }

                // segmentControl 변경
                // 기존 데이터 없는 경우에 데이터 요청, 아니면 요청 X
            case .changeMeetingStatus(let status):
                state.meetingStatus = status
                if status == .completed {
                    if state.completedList.isEmpty {
                        return .run { send in await send(.fetchMeetingList(.completed)) }
                    } else {
                        state.homeStatus = .normal
                    }
                }

                if status == .progress {
                    if state.progressList.isEmpty {
                        return .run { send in await send(.fetchMeetingList(.progress))}
                    } else {
                        state.homeStatus = .normal
                    }
                }
                return .none

                // 데이터 업데이트
            case .updateMeetingList(let status, let model):
                state.progressCount = model.progressCount
                state.completedCount = model.completedCount
                if status == .progress {
                    state.progressIndex += 1
                } else {
                    state.completedIndex += 1
                }
                if let meetings = model.meetings {
                    if status == .progress {
                        state.progressList.append(contentsOf: meetings)
                        let isEmpty = state.progressList.isEmpty
                        return .run { send in
                            await send(.changeHomeStatus(isEmpty ? .empty : .normal))
                        }
                    } else {
                        state.completedList.append(contentsOf: meetings)
                        let isEmpty = state.completedList.isEmpty
                        return .run { send in
                            await send(.changeHomeStatus(isEmpty ? .empty : .normal))
                        }
                    }
                }
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

                // MARK: - Child
                
                // Meeting Detail
            case .meetingDetailAction(.delegate(.onDisappear)):
                state.pushMeetingDetail = false
                state.meetingDetailId = nil
                return .none

            case .meetingDetailAction(.delegate(.deleteSuccess)):
                return .run { send in
                    await send(.refreshMeetingList)
                }

            case .meetingDetailAction(.delegate(.moveToLogin)):
                return .run { send in await send(.delegate(.moveToLogin)) }
                
            case .meetingDetailAction:
                return .none

            case .cameraButtonTapped:
                state.usingCamera = CameraFeature.State(
                    timer: TimerFeature.State(timerCount: 1)
                )
                return .none
                
            case .emergencyButtonTapped:
                state.usingEmergency = EmergencyFeature.State(
                    memberID: 0,
                    remainTimeUntilExpired: 1000
                )
                return .none
                
            case .usingEmergency:
                return .none

            case .usingCamera:
                return .none
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$usingCamera, action: /Action.usingCamera) {
            CameraFeature()
        }
        .ifLet(\.$usingEmergency, action: /Action.usingEmergency) {
            EmergencyFeature()
        }
    }
}
