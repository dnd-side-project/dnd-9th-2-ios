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

        // MARK: - Scope State

        var loginFeature: LoginFeature.State
        var mainTabFeature: MainTabFeature.State
    }

    enum Action: Equatable {

        // MARK: - Scope Action

        case login(LoginFeature.Action)
        case mainTab(MainTabFeature.Action)
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.loginFeature, action: /Action.login) {
            LoginFeature()
        }

        Scope(state: \.mainTabFeature, action: /Action.mainTab) {
            MainTabFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in
            switch action {

            // Login Feature

            case .login(.delegate(.moveToMainTab)):
                state.mainTabFeature = MainTabFeature.State(
                    homeFeature: HomeFeature.State(),
                    myPageFeature: MyPageFeature.State()
                )
                state.isLoggedIn = true
                return .none

            case .login:
                return .none

            // MainTab Feature

            case .mainTab(.delegate(.moveToLogin)):
                UserManager.shared.delete()
                state.isLoggedIn = false
                return .none

            case .mainTab:
                return .none
            }
        }
    }
}
