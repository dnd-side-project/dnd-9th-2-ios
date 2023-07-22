//
//  SignUpFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import ComposableArchitecture

struct SignUpNicknameFeature: ReducerProtocol {

    struct State: Equatable {
        var path = StackState<SignUpProfileImageFeature.State>()
    }

    enum Action: Equatable {

        // Button Tapped

        case nextButtonTapped
        case cancelButtonTapped

        // Screen Move

        case path(StackAction<SignUpProfileImageFeature.State, SignUpProfileImageFeature.Action>)
        case moveToHome

        // Delegate

        case delegate(Delegate)

        enum Delegate: Equatable {
            case successSignUp
        }
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {

        Reduce { state, action in

            switch action {

            // Button Tapped

            case .nextButtonTapped:
                return .none

            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }

            // Screen Move

            case let .path(.element(id: id, action: .delegate(.moveToHome))):
                state.path.pop(from: id)
                return .run { send in
                    await send(.moveToHome)
                }

            case .path:
                return .none

            case .moveToHome:
                return .run { send in
                    await send(.delegate(.successSignUp))
                    await self.dismiss()
                }

            // Delegate

            case .delegate:
                return . none
            }
        }
        .forEach(\.path, action: /Action.path) {
            SignUpProfileImageFeature()
        }
    }
}
