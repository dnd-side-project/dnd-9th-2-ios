//
//  TimerFeature.swift
//  Baggle
//
//  Created by youtak on 2023/08/05.
//

import SwiftUI

import ComposableArchitecture

struct TimerFeature: ReducerProtocol {

    struct State: Equatable {
        var timerCount: Int
        var isTimerOver: Bool = false
    }

    enum Action: Equatable {
        case start
        case cancel
        
        // MARK: - Timer

        case timerTick
        case timerOver
    }

    enum CancelID { case timer }

    @Dependency(\.continuousClock) var clock

    var body: some ReducerProtocolOf<Self> {
        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .start:
                
                if state.timerCount <= 0 {
                    return .run { send in await send(.timerOver)}
                }

                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.timer)
                
            case .cancel:
                return .cancel(id: CancelID.timer)
                // MARK: - Timer

            case .timerTick:
                state.timerCount -= 1

                if state.timerCount <= 0 {
                    return .run { send in await send(.timerOver) }
                } else {
                    return .none
                }

            case .timerOver:
                state.isTimerOver = true
                return .cancel(id: CancelID.timer)
            }
        }
    }
}
