//
//  LoginFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import ComposableArchitecture

struct LoginFeature: ReducerProtocol {

    struct State: Equatable {
        @PresentationState var signUpNickname: SignUpNicknameFeature.State?
    }

    enum Action: Equatable {

        // Button Tapped

        case kakaoLoginButtonTapped
        case signUpButtonTapped

        // Dependency

        case loginSuccess

        // Child Action

        case signUpNickname(PresentationAction<SignUpNicknameFeature.Action>)
    }

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {

            // Button Tapped

            case .kakaoLoginButtonTapped:
                return .run { send in
                    await send(.loginSuccess)
                }

            case .signUpButtonTapped:
                state.signUpNickname = SignUpNicknameFeature.State()
                return .none

            // Dependency

            case .loginSuccess:
                return .none

            // Child Action

            case .signUpNickname(.presented(.delegate(.successSignUp))):
                return .run { send in
                    await send(.loginSuccess)
                }

            case .signUpNickname:
                return .none
            }
        }
        .ifLet(\.$signUpNickname, action: /Action.signUpNickname) {
            SignUpNicknameFeature()
        }
    }
}
