//
//  LoginView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import AuthenticationServices
import SwiftUI

import ComposableArchitecture
import KakaoSDKUser

struct LoginView: View {

    typealias LoginViewStore = ViewStore<LoginFeature.State, LoginFeature.Action>

    let store: StoreOf<LoginFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack {

                Spacer()

                Circle()
                    .fill(Color.blue)
                    .frame(width: 200, height: 200)
                    .padding()

                Spacer()

                kakaoLoginButton()
                appleLoginButton()
                signUp()

                Spacer()
                Spacer()
            }
            .fullScreenCover(store: self.store.scope(
                state: \.$signUpNickname,
                action: { .signUpNickname($0) })
            ) { signupStore in
                SignUpNicknameView(store: signupStore)
            }
            .transaction { transaction in
                transaction.disablesAnimations = viewStore.disableDismissAnimation
            }
        }
    }
}

extension LoginView {

    func requestKakaoLogin() async throws -> String {
        typealias TokenContinuation = CheckedContinuation<String, Error>
        return try await withCheckedThrowingContinuation({ (continuation: TokenContinuation) in
            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                        if let error {
                            dump(error)
                            continuation.resume(throwing: error)
                        } else {
                            if let accessToken = oauthToken?.accessToken {
                                continuation.resume(returning: accessToken)
                            }
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        if let error {
                            dump(error)
                            continuation.resume(throwing: error)
                        } else {
                            if let accessToken = oauthToken?.accessToken {
                                continuation.resume(returning: accessToken)
                            }
                        }
                    }
                }
            }
        })
    }

    func kakaoLoginButton() -> some View {
        Button {
            Task {
                do {
                    let token = try await requestKakaoLogin()
                    ViewStore(self.store).send(.loginButtonTapped(.kakao, token))
                } catch {
                    print("error: \(error)")
                }
            }
        } label: {
            Text("카카오 로그인")
        }
    }

    func appleLoginButton() -> some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        guard let identityToken = appleIDCredential.identityToken,
                              let token = String(data: identityToken, encoding: .utf8)
                        else { return }
                        ViewStore(self.store).send(.loginButtonTapped(.apple, token))
                    default:
                        break
                    }
                case .failure(let error):
                    print("error: ", error.localizedDescription)
                    ViewStore(self.store).send(.loginFail)
                }
            }
        )
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
        .cornerRadius(5)
    }

    func signUp() -> some View {
        Button {
            ViewStore(self.store).send(.signUpButtonTapped)
        } label: {
            HStack {

                Spacer()

                Text("회원 가입")
                    .font(.title)
                    .padding()

                Spacer()
            }
        }
        .padding()
        .tint(Color.red)
        .buttonStyle(.borderedProminent)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: Store(
                initialState: LoginFeature.State(),
                reducer: LoginFeature()._printChanges()
            )
        )
    }
}
