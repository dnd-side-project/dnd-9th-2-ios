//
//  JoinMeetingFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct JoinMeetingFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State
        var meetingId: Int
        var joinMeeingStatus: JoinMeetingStatus
        var isAlertPresented: Bool = false
    }

    enum Action: Equatable {
        // MARK: - Scope Action
        
        case onAppear
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
                if state.joinMeeingStatus == .expired {
                    return .run { send in await send(.presentAlert) }
                }
                return .none
                
            case .exitButtonTapped:
                return .run { _ in await self.dismiss() }

            case .joinButtonTapped:
                let id = state.meetingId
                return .run { send in
                    if await joinMeetingService.postJoinMeeting(id) == .success {
                        await send(.joinSuccess)
                    } else {
                        await send(.joinFailed)
                    }
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
