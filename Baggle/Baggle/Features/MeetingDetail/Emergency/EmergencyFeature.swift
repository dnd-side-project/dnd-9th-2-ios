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
        var isTimeExpired: Bool = false
        var isEmergency: Bool = false
        var isFetched: Bool = false

        var alertType: AlertEmergencyType?
        
        // Child
        var timer = TimerFeature.State(timerCount: 300)
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
    
        // Alert
        case alertButtonTapped
        case presentBaggleAlert(Bool)
        
        // Network
        case handleEmergencyStatus(EmergencyServiceResult)
        
        // Child
        case timerAction(TimerFeature.Action)

        // Delegate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case usingCamera
            case moveToBack
            case moveToLogin
            case updateEmergencyState(Date)
        }
    }

    enum CancelID { case emergencyExpiredTimer }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.emergencyService) var emergencyService
    @Dependency(\.continuousClock) var clock

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope
        Scope(state: \.timer, action: /Action.timerAction) {
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
                state.isFetched = true

                let id = state.memberID
                return .run { send in
                    let result = await emergencyService.emergency(id)
                    await send(.handleEmergencyStatus(result))
                }

            case .cameraButtonTapped:
                return .run { send in await send(.delegate(.usingCamera)) }

            case .alertButtonTapped:
                guard let alertType = state.alertType else {
                    return .none
                }
                
                switch alertType {
                case .invalidAuthorizationTime:
                    return .run { send in await send(.delegate(.moveToBack)) }
                case .notFound, .networkError:
                    state.isFetched = false
                    return .none
                case .unAuthorized, .userError:
                    return .run { send in await send(.delegate(.moveToLogin)) }
                }
                
            case .presentBaggleAlert(let isPresented):
                if !isPresented {
                    state.alertType = nil
                }
                return .none
                
                // Network
                
            case .handleEmergencyStatus(let status):
                
                switch status {
                case .success(let certificationTime):
                    let timerCount = certificationTime.authenticationTimeout()
                    state.timer = TimerFeature.State(timerCount: timerCount)
                    state.isEmergency = true
                    return .run { send in
                        await send(.delegate(.updateEmergencyState(certificationTime)))
                    }
                case .invalidAuthorizationTime:
                    state.alertType = .invalidAuthorizationTime
                    return .none
                case .unAuthorized:
                    state.alertType = .unAuthorized
                    return .none
                case .notFound:
                    state.alertType = .notFound
                    return .none
                case .userError:
                    state.alertType = .userError
                    return .none
                case .networkError(let description):
                    state.alertType = .networkError(description)
                    return .none
                }
                
                // Timer
            case .timerAction:
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
