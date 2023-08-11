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

        case appleLoginButtonTapped(String)
        case kakaoLoginButtonTapped
        case moveToSignUp(LoginPlatform, String)

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

            case .appleLoginButtonTapped(let token):
                print("확인용 - token: \(token), platform: apple")
                return .run { send in
                    // 로그인 통신
                    // 성공이면 loginSuccess, 새로운 유저면 moveToSignUp, 실패면 loginFail
//                    await send(.loginSuccess)
                    await send(.moveToSignUp(.apple, token))
                }

            case .kakaoLoginButtonTapped:
                return .run { send in
                    do {
                        let token = try await kakaoLoginService.login()
                        print("확인용 - token: \(token), platform: kakao")
                        // 로그인 통신
                        // 성공이면 loginSuccess, 새로운 유저면 moveToSignUp, 실패면 loginFail
//                        await send(.moveToSignUp(.kakao, token))
                        await send(.loginSuccess)
                    } catch {
                        print("카카오 로그인 에러")
                        print(error)
                    }
                }

            case .moveToSignUp(let platform, let token):
                state.disableDismissAnimation = false // 화면 전환 애니메이션 활성화

                state.signUpNickname = SignUpFeature.State(
                    loginPlatform: platform,
                    socialLoginToken: token)
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
