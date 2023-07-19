//
//  LoginFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import ComposableArchitecture

struct LoginFeature: ReducerProtocol {

    struct State: Equatable {
    }

    enum Action: Equatable {
        case kakaoLoginButtonTapped

        case delegate(Delegate)

        enum Delegate: Equatable {
            case moveToMainTab
        }
    }

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {
            case .kakaoLoginButtonTapped:
                return .run { send in
                    await send(.delegate(.moveToMainTab))
                }

            case .delegate:
                return .none
            }
        }
    }
}
