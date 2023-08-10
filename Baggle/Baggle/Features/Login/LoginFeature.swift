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

        @PresentationState var signUpNickname: SignUpFeature.State?
    }

    enum Action: Equatable {

        // MARK: - Button Tapped

        case loginButtonTapped(LoginPlatform, String)
        case kakaoLoginButtonTapped
        case appleLoginButtonTapped
        case signUpButtonTapped

        // MARK: - Dependency

        case loginSuccess
        case loginFail

        // MARK: - Child Action

        case signUpNickname(PresentationAction<SignUpFeature.Action>)
    }

    @Dependency(\.kakaoLoginService) private var kakaoLoginService

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {

                // MARK: - Button Tapped

            case .loginButtonTapped(let platform, let token):
                print("확인용 - token: \(token), platform: \(platform)")
                return .run { send in
                    await send(.loginSuccess)
                }

            case .kakaoLoginButtonTapped:
                return .run { _ in
                    do {
                        let token = try await kakaoLoginService.login()
                        print("카카오 토큰 \(token)")
                    } catch {
                        print("카카오 로그인 에러")
                        print(error)
                    }
                }

            case .appleLoginButtonTapped:
                return .none

            case .signUpButtonTapped:
                state.disableDismissAnimation = false // 화면 전환 애니메이션 활성화

                state.signUpNickname = SignUpFeature.State()
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
            SignUpFeature()
        }
    }
}
