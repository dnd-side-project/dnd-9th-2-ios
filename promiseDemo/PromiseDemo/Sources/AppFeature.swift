//
//  AppFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import ComposableArchitecture

struct AppFeature: ReducerProtocol {

    struct State: Equatable {
        var isLoggedIn: Bool
        var loginFeature: LoginFeature.State
    }

    enum Action: Equatable {
        case login(LoginFeature.Action)
    }

    var body: some ReducerProtocolOf<Self> {

        Scope(state: \.loginFeature, action: /Action.login) {
            LoginFeature()
        }

        Reduce { state, action in
            switch action {

            case .login(.completeLogin):
                state.isLoggedIn = true
                return .none

            case .login:
                return .none
            }
        }
    }
}
