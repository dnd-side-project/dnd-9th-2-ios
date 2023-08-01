//
//  CreateMeetingDateFeature.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import ComposableArchitecture

struct CreateDateFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State
        @PresentationState var yearMonthDate: YearMonthDateFeature.State?
        @PresentationState var hourMinute: HourMinuteFeature.State?
    }

    enum Action: Equatable {

        case nextButtonTapped
        case yearMonthDateButtonTapped
        case hourMinuteButtonTapped

        // Child
        case yearMonthDate(PresentationAction<YearMonthDateFeature.Action>)
        case hourMinute(PresentationAction<HourMinuteFeature.Action>)
        // Delegate
        case delegate(Delegate)

        enum Delegate {
            case moveToNext
        }
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

                // Tap

            case .nextButtonTapped:
                return .run { send in await send(.delegate(.moveToNext)) }

            case .yearMonthDateButtonTapped:
                state.yearMonthDate = YearMonthDateFeature.State()
                return .none

            case .hourMinuteButtonTapped:
                state.hourMinute = HourMinuteFeature.State()
                return .none

                // Child
            case .yearMonthDate:
                return .none

            case .hourMinute:
                return .none
                // Delegate

            case .delegate(.moveToNext):
                return .none
            }
        }
        .ifLet(\.$yearMonthDate, action: /Action.yearMonthDate) {
            YearMonthDateFeature()
        }
        .ifLet(\.$hourMinute, action: /Action.hourMinute) {
            HourMinuteFeature()
        }
    }
}
