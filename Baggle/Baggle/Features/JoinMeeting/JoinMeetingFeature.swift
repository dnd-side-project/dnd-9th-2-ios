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
        
        // joinMeeting
        var meetingId: Int
        var joinMeeingStatus: JoinMeetingStatus
        
        // alert
        var alertType: AlertJoinMeetingType?
    }

    enum Action: Equatable {
        
        // view
        case onAppear
        
        // button
        case exitButtonTapped
        case joinButtonTapped
        
        // response
        case joinSuccess
        case joinFailed
        
        // alert
        case presentAlert(Bool)
        case alertButtonTapped
        
        // meetingDetail
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
                if case let .expired(error) = state.joinMeeingStatus {
                    switch error {
                    case .overlapMeetingTime:
                        state.alertType = .overlap
                    case .exceedMemberCount:
                        state.alertType = .exceedMemberCount
                    default:
                        state.alertType = .expired
                    }
                    return .run { send in await send(.presentAlert(true)) }
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
                
            case .presentAlert(let isPresented):
                if !isPresented {
                    state.alertType = nil
                }
                return .none
                
            case .alertButtonTapped:
                if state.alertType != nil { state.alertType = nil }
                return .none
            }
        }
    }
}
