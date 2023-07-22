//
//  SignUpProfileImageFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import ComposableArchitecture

struct SignUpProfileImageFeature: ReducerProtocol {

    struct State: Equatable {
    }

    enum Action: Equatable {
        case nextButtonTapped
        case signUpSuccess
        case signUpFailed

        case delegate(Delegate)

        enum Delegate: Equatable {
            case moveToHome
        }
    }

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {

            case .nextButtonTapped:
                return .run { send in
                    // todo: 실패 Alert
                    await send(.signUpSuccess)
                }

            case .signUpSuccess:
                return .run { send in
                    await send(.delegate(.moveToHome))
                }

            case .signUpFailed:
                // todo: 실패 Alert
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
