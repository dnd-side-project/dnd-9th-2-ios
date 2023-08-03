//
//  CreateMeetingMemoFeature.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import ComposableArchitecture

struct CreateMemoFeature: ReducerProtocol {

    struct State: Equatable {
        // Child
        var textEditorState = BaggleTextFeature.State(
            maxCount: 50,
            textFieldState: .inactive
        )
    }

    enum Action: Equatable {

        // Button
        case nextButtonTapped

        // View
        case moveToNextScreen

        // Child
        case textEditorAction(BaggleTextFeature.Action)

        // Delegate
        case delegate(Delegate)

        enum Delegate {
            case moveToNext
        }
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.textEditorState, action: /Action.textEditorAction) {
            BaggleTextFeature()
        }

        // MARK: - Reduce

        Reduce { _, action in

            switch action {

                // Button

            case .nextButtonTapped:
                return .run { send in await send(.moveToNextScreen) }

            case .moveToNextScreen:
                return .run { send in await send(.delegate(.moveToNext)) }

                // TextField

            case .textEditorAction:
                return .none

                // Delegate

            case .delegate(.moveToNext):
                return .none
            }
        }
    }
}
