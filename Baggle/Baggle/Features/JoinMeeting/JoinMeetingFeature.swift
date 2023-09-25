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
        
        // MARK: - Join Meeting Model
        
        var meetingId: Int
        var joinMeetingStatus: JoinMeetingResult
        
        // MARK: - Alert
        
        var isAlertPresented: Bool = false
        var alertType: AlertJoinMeetingType?
    }

    enum Action: Equatable {
        
        // MARK: - View
        
        case onAppear
        
        // MARK: - Button
        
        case exitButtonTapped
        case joinButtonTapped
        
        // MARK: - Response

        case joinSuccess
        case joinFailed
        
        // MARK: - Alert

        case presentAlert(Bool)
        case alertTypeChanged(AlertJoinMeetingType)
        case alertButtonTapped
        
        // MARK: - Move

        case moveToMeetingDetail
        
        // MARK: - Delegate
        case delegate(Delegate)
        
        enum Delegate {
            case moveToLogin
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.joinMeetingService) var joinMeetingService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
                
                // MARK: - View
                
            case .onAppear:
                if case let .expired(error) = state.joinMeetingStatus {
                    switch error {
                    case .duplicatedMeeting:
                        return .run { send in await send(.alertTypeChanged(.overlap))}
                    case .exceedMemberCount:
                        return .run { send in await send(.alertTypeChanged(.exceedMemberCount))}
                    default:
                        return .run { send in await send(.alertTypeChanged(.expired))}
                    }
                }
                return .none
                
                // MARK: - Button
                
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

                // MARK: - Response
                
            case .joinSuccess:
                return .run { send in await send(.moveToMeetingDetail) }

            case .joinFailed:
                return .none
                
                // MARK: - Alert
                
            case .presentAlert(let isPresented):
                if !isPresented {
                    state.alertType = nil
                }
                state.isAlertPresented = isPresented
                return .none
            
            case .alertTypeChanged(let alertType):
                state.alertType = alertType
                state.isAlertPresented = true
                return .none
            
            case .alertButtonTapped:
                guard let alertType = state.alertType else {
                    return .none
                }
                state.alertType = nil
                
                switch alertType {
                case .expired, .overlap, .exceedMemberCount, .networkError:
                    return .run { _ in await self.dismiss() }
                case .userError:
                    return .run { send in await send(.delegate(.moveToLogin))}
                }
                
                // MARK: - Move
                
            case .moveToMeetingDetail:
                let id = state.meetingId
                return .run { _ in
                    await self.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
                        postObserverAction(.moveMeetingDetail, object: id)
                    }
                }
                
                // MARK: - Delegate
                
            case .delegate:
                return .none
            }
        }
    }
}
