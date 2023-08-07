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
        var isEmergency: Bool = false

        // Child
        var timerState = TimerFeature.State(targetDate: Date().later(minutes: 1).later(seconds: 10))
    }

    enum Action: Equatable {
        // Tap
        case closeButtonTapped
        case emergencyButtonTapped

        // Child
        case timerAction(TimerFeature.Action)
    }

    @Dependency(\.dismiss) var dismiss

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
                state.isEmergency = true
                return .none

                // Timer
            case .timerAction:
                return .none
            }
        }
    }
}
