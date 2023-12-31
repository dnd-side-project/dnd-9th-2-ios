//
//  HomeFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/26.
//

import Foundation
import SwiftUI

import ComposableArchitecture

struct HomeFeature: ReducerProtocol {

    struct State: Equatable {

        var user: User = UserManager.shared.user ?? User.error()
        var homeStatus: HomeStatus = .empty

        // 예정된 약속(progress), 지난 약속(completed)
        var meetingStatus: MeetingHomeStatus = .scheduled
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
        
        // 초기화
        var isRefreshing: Bool = false
    }

    enum Action: Equatable {

        // View
        case onAppear
        case scrollReachEnd(Int)

        // State 관리
        case changeHomeStatus(HomeStatus)
        case fetchMeetingList(MeetingHomeStatus)
        case updateMeetingList(MeetingHomeStatus, HomeMeetingList)
        case refreshMeetingList
        case changeMeetingStatus(MeetingHomeStatus)

        // 모임 상세
        case pushToMeetingDetail(Int)
        
        // Delegate
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case moveToLogin
            case moveToMeetingDetail(Int)
            case alert(AlertHomeType)
        }
    }
    
    @Dependency(\.meetingListService) var meetingListService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .onAppear:
                guard let user = UserManager.shared.user else {
                    return .run { send in await send(.changeHomeStatus(.error)) }
                }
                
                state.user = user
                if state.progressList.isEmpty && state.completedList.isEmpty {
                    return .run { send in
                        await send(.fetchMeetingList(.scheduled))
                    }
                } else {
                    return .none
                }
                
                // 스크롤 끝에 닿은 경우 데이터 요청
            case .scrollReachEnd(let index):
                // meetingStatus에 따라 fetchMeetingList 요청
                let status = state.meetingStatus
                if status == .scheduled {
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
                let page = (status == .scheduled) ? state.progressIndex : state.completedIndex
                let requestModel = HomeRequestModel(status: status, page: page, size: state.size)
                return .run { send in
                    let result = await meetingListService.fetchMeetingList(requestModel)
                    switch result {
                    case .success(let data):
                        await send(.updateMeetingList(status, data))
                    case .networkError:
                        await send(.changeHomeStatus(.error))
                    case .userError:
                        await send(.delegate(.alert(.userError)))
                    }
                }

                // 초기화
            case .refreshMeetingList:
                state.isRefreshing = true
                state.homeStatus = .loading
                state.meetingStatus = .scheduled
                state.progressIndex = 0
                state.completedIndex = 0
                state.progressList.removeAll()
                state.completedList.removeAll()
                state.requestedProgressIndex.removeAll()
                state.requestedCompletedIndex.removeAll()
                let requestModel = HomeRequestModel(status: .scheduled, page: 0, size: state.size)
                return .run { send in
                    let result = await meetingListService.fetchMeetingList(requestModel)
                    switch result {
                    case .success(let data):
                        await send(.updateMeetingList(.scheduled, data))
                    case .networkError:
                        await send(.changeHomeStatus(.error))
                    case .userError:
                        await send(.delegate(.alert(.userError)))
                    }
                }

                // segmentControl 변경
                // 기존 데이터 없는 경우에 데이터 요청, 아니면 요청 X
            case .changeMeetingStatus(let status):
                state.meetingStatus = status
                if status == .past {
                    if state.completedList.isEmpty {
                        return .run { send in await send(.fetchMeetingList(.past)) }
                    } else {
                        state.homeStatus = .normal
                    }
                }

                if status == .scheduled {
                    if state.progressList.isEmpty {
                        return .run { send in await send(.fetchMeetingList(.scheduled))}
                    } else {
                        state.homeStatus = .normal
                    }
                }
                return .none

                // 데이터 업데이트
            case .updateMeetingList(let status, let model):
                state.progressCount = model.progressCount
                state.completedCount = model.completedCount
                if status == .scheduled {
                    state.progressIndex += 1
                } else {
                    state.completedIndex += 1
                }
                if let meetings = model.meetings {
                    if status == .scheduled {
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
                return .run { send in await send(.delegate(.moveToMeetingDetail(id))) }

            case .delegate:
                return .none
            }
        }
    }
}
