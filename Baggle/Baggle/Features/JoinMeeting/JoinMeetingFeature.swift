//
//  JoinMeetingFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

enum JoinMeetingState: Equatable {
    case enable(JoinMeeting)
    case expired
    case joined
    case loading
}

struct JoinMeetingFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State
        var meetingId: Int
        var joinMeeingState: JoinMeetingState = .loading
        var isAlertPresented: Bool = false
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case updateState(JoinMeetingState)
        case exitButtonTapped
        case joinButtonTapped
        case joinSuccess
        case joinFailed
        case presentAlert
        case moveToMeetingDetail
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.joinMeetingService) var joinMeetingService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .onAppear:
                let meetingId = state.meetingId
                return .run { send in
                    let state = await joinMeetingService.fetchMeetingInfo(meetingId)
                    await send(.updateState(state))
                }
                
            case .updateState(let joinMeetingState):
                switch joinMeetingState {
                case .enable(let joinMeetingData):
                    state.joinMeeingState = .enable(joinMeetingData)
                case .joined:
                    let id = state.meetingId
                    return .run { _ in
                        await self.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
                            postObserverAction(.moveMeetingDetail, object: id)
                        }
                    }
                case .expired:
                    state.joinMeeingState = joinMeetingState
                    // alert 띄우기
                    return .run { send in await send(.presentAlert) }
                case .loading:
                    state.joinMeeingState = joinMeetingState
                }
                return .none
                
            case .exitButtonTapped:
                return .run { _ in await self.dismiss() }

            case .joinButtonTapped:
                return .run { send in
                    // id 값으로 참여 통신
                    await send(.joinSuccess)
                }

            case .joinSuccess:
                return .run { send in await send(.moveToMeetingDetail) }

            case .joinFailed:
                return .none
                
            case .moveToMeetingDetail:
                let id = state.meetingId
                return .run { _ in
                    await self.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
                        postObserverAction(.moveMeetingDetail, object: id)
                    }
                }
                
            case .presentAlert:
                state.isAlertPresented.toggle()
                return .none
            }
        }
    }
}
