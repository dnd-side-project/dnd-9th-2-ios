//
//  EmergencyFeature.swift
//  Baggle
//
//  Created by youtak on 2023/08/07.
//

import SwiftUI

import ComposableArchitecture

struct EmergencyFeature: ReducerProtocol {

    struct State: Equatable {
        let meetingID: Int
        var isEmergency: Bool = false

        // Child
        var timerState = TimerFeature.State(timerCount: 30)
    }

    enum Action: Equatable {
        // Tap
        case closeButtonTapped
        case emergencyButtonTapped
        case cameraButtonTapped
        
        case emergencySuccess
        case emergencyFail

        // Child
        case timerAction(TimerFeature.Action)

        // Delegate
        case delegate(Delegate)

        enum Delegate {
            case usingCamera
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.emergencyService) var emergencyService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope
        Scope(state: \.timerState, action: /Action.timerAction) {
            TimerFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }

            case .emergencyButtonTapped:
                let id = state.meetingID
                return .run { send in
                    if await emergencyService.emergency(id) {
                        await send(.emergencySuccess)
                    } else {
                        await send(.emergencyFail)
                    }
                }
                
            case .emergencySuccess:
                state.isEmergency = true
                return .none
                
            case .emergencyFail:
                print("emergencyFail")
                return .none

            case .cameraButtonTapped:
                return .run { send in await send(.delegate(.usingCamera)) }

                // Timer
            case .timerAction:
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
