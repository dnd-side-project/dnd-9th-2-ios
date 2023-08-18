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
        
        let memberID: Int
        var remainTimeUntilExpired: Int
        var isEmergency: Bool = false
        var isTimeExpired: Bool = false

        // Child
        var timerState = TimerFeature.State(timerCount: 30)
    }

    enum Action: Equatable {
        
        // Life Cycle
        case onAppear
        case onDisappear
        
        case cancelTimer
        case timeExpired
        case timeExpiredChanged(Bool)
        
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

    enum CancelID { case emergencyExpiredTimer }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.emergencyService) var emergencyService
    @Dependency(\.continuousClock) var clock

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope
        Scope(state: \.timerState, action: /Action.timerAction) {
            TimerFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
                
            case .onAppear:
                let remainTime = state.remainTimeUntilExpired
                
                if remainTime <= 0 {
                    return .run { send in await send(.timeExpired)}
                }
                
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(remainTime)) {
                        await send(.timeExpired)
                        await send(.cancelTimer)
                    }
                }
                .cancellable(id: CancelID.emergencyExpiredTimer)

            case .onDisappear:
                return .cancel(id: CancelID.emergencyExpiredTimer)
                
            case .cancelTimer:
                return .cancel(id: CancelID.emergencyExpiredTimer)
                
            case .timeExpired:
                state.isTimeExpired = true
                return .none
                
            case .timeExpiredChanged(let isPresent):
                return isPresent ? .none : .run { _ in await self.dismiss() }
                
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }

            case .emergencyButtonTapped:
                let id = state.memberID
                return .run { send in
                    if await emergencyService.emergency(id) == EmergencyServiceStatus.success {
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
