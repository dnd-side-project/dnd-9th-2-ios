//
//  BaggleTextFieldFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/29.
//

import ComposableArchitecture

struct BaggleTextFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State

        var text: String = ""
        var maxCount: Int
        var textFieldState: TextFieldState
        var errorMessage: String?
        var isFocused: Bool = false
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case textChanged(String)
        case changeState(TextFieldState)
        case isFocused(Bool)
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .textChanged(let newText):
                if state.text != newText && state.errorMessage != nil {
                    if state.isFocused {
                        state.textFieldState = .active
                    } else {
                        state.textFieldState = (newText.isEmpty ? .inactive : .valid)
                    }
                    state.errorMessage = nil
                }

                state.text = String(newText.prefix(state.maxCount))

                return .none

            case .isFocused(let isFocus):
                state.isFocused.toggle()

                if let error = state.errorMessage {
                    state.textFieldState = .invalid(error)
                } else {
                    if isFocus {
                        state.textFieldState = .active
                    } else {
                        state.textFieldState = state.text.isEmpty ? .inactive : .valid
                    }
                }

                return .none

            case .changeState(let newState):
                if case let .invalid(error) = newState {
                    state.errorMessage = error
                } else {
                    state.errorMessage = nil
                }
                state.textFieldState = newState

                return .none
            }
        }
    }
}
