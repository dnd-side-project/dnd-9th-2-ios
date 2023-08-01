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
    }

    enum Action: Equatable {

        case nextButtonTapped
        case yearMonthDateButtonTapped

        // Child
        case yearMonthDate(PresentationAction<YearMonthDateFeature.Action>)
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

                // Child
            case .yearMonthDate:
                return .none

                // Delegate

            case .delegate(.moveToNext):
                return .none
            }
        }
        .ifLet(\.$yearMonthDate, action: /Action.yearMonthDate) {
            YearMonthDateFeature()
        }
    }
}
