//
//  CreateMeetingPlaceFeature.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import ComposableArchitecture

struct CreatePlaceFeature: ReducerProtocol {

    struct State: Equatable {

        // Button
        var nextButtonDisabled: Bool = true

        // Child State
        var textFieldState = BaggleTextFeature.State(
            maxCount: 15,
            textFieldState: .inactive,
            isFocused: true
        )
    }

    enum Action: Equatable {

        // Tap
        case nextButtonTapped
        case submitButtonTapped

        // Move Screen
        case moveToNextScreen

        // Child Action
        case textFieldAction(BaggleTextFeature.Action)

        // Delegate
        case delegate(Delegate)

        enum Delegate {
            case moveToNext
        }
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.textFieldState, action: /Action.textFieldAction) {
            BaggleTextFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
                // Tap
            case .nextButtonTapped:
                return .run { send in await send(.moveToNextScreen)}

            case .submitButtonTapped:
                if state.textFieldState.text.isEmpty {
                    return .run { send in
                        await send(.textFieldAction(.changeState(.invalid("장소를 입력해주세요."))))
                    }
                } else {
                    return .run { send in await send(.moveToNextScreen)}
                }

            case .moveToNextScreen:
                return .run { send in await send(.delegate(.moveToNext)) }

                // TextField
            case let .textFieldAction(.textChanged(text)):
                if text.isEmpty {
                    state.nextButtonDisabled = true
                } else {
                    state.nextButtonDisabled = false
                }
                return .none

            case .textFieldAction:
                return .none

            case .delegate(.moveToNext):
                return .none
            }
        }
    }
}
