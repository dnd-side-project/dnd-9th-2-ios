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
        case kakaoLoginButtonTapped
        case signUpButtonTapped
        case loginSuccess

        case signUpNickname(PresentationAction<SignUpNicknameFeature.Action>)
    }

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {
            case .kakaoLoginButtonTapped:
                return .run { send in
                    await send(.loginSuccess)
                }

            case .signUpButtonTapped:
                state.signUpNickname = SignUpNicknameFeature.State()
                return .none

            case .loginSuccess:
                return .none

            case .signUpNickname:
                return .none
            }
        }
        .ifLet(\.$signUpNickname, action: /Action.signUpNickname) {
            SignUpNicknameFeature()
        }
    }
}
