//
//  LoginFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import ComposableArchitecture

struct LoginFeature: ReducerProtocol {

    struct State: Equatable {

        var disableDismissAnimation: Bool = false

        // MARK: - Child State

        @PresentationState var signUpNickname: SignUpNicknameFeature.State?
    }

    enum Action: Equatable {

        // MARK: - Button Tapped

        case loginButtonTapped(String)
        case signUpButtonTapped

        // MARK: - Dependency

        case loginSuccess
        case loginFail

        // MARK: - Child Action

        case signUpNickname(PresentationAction<SignUpNicknameFeature.Action>)
    }

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {

                // MARK: - Button Tapped

            case .loginButtonTapped(let token):
                print("token 확인용: \(token)")
                return .run { send in
                    await send(.loginSuccess)
                }

            case .signUpButtonTapped:
                state.disableDismissAnimation = false // 화면 전환 애니메이션 활성화

                state.signUpNickname = SignUpNicknameFeature.State()
                return .none

                // MARK: - Dependency

            case .loginSuccess:
                return .none

            case .loginFail:
                return .none

                // MARK: - Child Action

            case .signUpNickname(.presented(.delegate(.successSignUp))):
                state.disableDismissAnimation = true // 홈 화면 이동시 화면 전환 애니메이션 비활성화

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
