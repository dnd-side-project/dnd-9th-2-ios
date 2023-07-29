//
//  BaggleTextFieldFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/29.
//

import ComposableArchitecture

struct BaggleTextFieldFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State

        var text: String = ""
        var maxCount: Int
        var textFieldState: TextFieldState
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
                if newText.count > state.maxCount {
                    state.text = String(newText.prefix(state.maxCount))
                } else {
                    state.text = newText
                }
                return .none

            case .isFocused(let isFocus):
                state.textFieldState = isFocus ? .active : (state.text.isEmpty ? .inactive : .valid)
                return .none

            case .changeState(let newState):
                state.textFieldState = newState
                return .none
            }
        }
    }
}
