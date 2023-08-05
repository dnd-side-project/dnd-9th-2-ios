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
        var targetDate: Date = Date().later(seconds: 80)

        var timerCount: Int = 0
        var isTimerRunning: Bool = false
        var isTimerOver: Bool = false
    }

    enum Action: Equatable {
        case onAppear

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
            case .onAppear:
                state.timerCount = state.targetDate.remainingTime()

                if state.timerCount <= 0 {
                    return .run { send in await send(.timerOver)}
                }

                state.isTimerRunning = true

                if state.isTimerRunning {
                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }

                // MARK: - Timer

            case .timerTick:
                state.timerCount -= 1

                if state.timerCount <= 0 {
                    state.isTimerRunning = false
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
