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

        // Navigation Bar
        case backButtonTapped
        case closeButtonTapped
        
        // Tap
        case nextButtonTapped
        case submitButtonTapped

        // Move Screen
        case moveToNextScreen

        // Child Action
        case textFieldAction(BaggleTextFeature.Action)

        // Delegate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case moveToNext(String)
            case moveToBack
            case moveToHome
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
                
                // Navigation Bar
            case .backButtonTapped:
                return .run { send in await send(.delegate(.moveToBack))}
                
            case .closeButtonTapped:
                return .run { send in await send(.delegate(.moveToHome))}
                
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
                let place = state.textFieldState.text
                return .run { send in await send(.delegate(.moveToNext(place))) }

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

                // Delegate
                
            case .delegate(.moveToNext):
                return .none
                
            case .delegate(.moveToBack):
                return .none
                
            case .delegate(.moveToHome):
                return .none
            }
        }
    }
}
