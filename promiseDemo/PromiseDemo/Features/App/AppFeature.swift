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
        var mainTabFeature: MainTabFeature.State
    }

    enum Action: Equatable {
        case login(LoginFeature.Action)
        case logout(MainTabFeature.Action)
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.loginFeature, action: /Action.login) {
            LoginFeature()
        }

        Scope(state: \.mainTabFeature, action: /Action.logout) {
            MainTabFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in
            switch action {

            // Login Feature

            case .login(.loginSuccess):
                state.isLoggedIn = true
                return .none

            case .login:
                return .none

            // MainTab Feature

            case .logout(.logoutMainTab(.logoutMyPage)):
                state.isLoggedIn = false
                return .none

            case .logout:
                return .none
            }
        }
    }
}
