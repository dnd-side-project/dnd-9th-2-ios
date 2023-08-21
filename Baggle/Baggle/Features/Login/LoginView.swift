//
//  LoginView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import AuthenticationServices
import SwiftUI

import ComposableArchitecture

struct LoginView: View {

    typealias LoginViewStore = ViewStore<LoginFeature.State, LoginFeature.Action>

    let store: StoreOf<LoginFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in

            ZStack {

                LottieView(lottieType: .splash, completion: {
                    viewStore.send(.completeSplashAnimation)
                })
                .edgesIgnoringSafeArea(.all)

                if viewStore.completeSplashAnimation {
                    VStack(spacing: 8) {

                        Spacer()
                        kakaoLoginButton()
                        appleLoginButton()
                            .padding(.bottom, 36)
                    }
                    .transition(.opacity.animation(.easeIn(duration: 0.3)))
                }
            }
            .fullScreenCover(store: self.store.scope(
                state: \.$signUpNickname,
                action: { .signUpNickname($0) })
            ) { signupStore in
                SignUpView(store: signupStore)
            }
            .transaction { transaction in
                transaction.disablesAnimations = viewStore.disableDismissAnimation
            }
        }
    }
}

extension LoginView {

    func kakaoLoginButton() -> some View {
        Button {
            ViewStore(self.store, observe: { $0 }).send(.kakaoLoginButtonTapped)
        } label: {
            HStack(spacing: 6) {
                Image.Icon.kakao

                Text("카카오로 로그인")
            }
        }
        .buttonStyle(KakaoLoginStyle())
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
                        ViewStore(self.store, observe: { $0 })
                            .send(.appleLoginButtonTapped(token))
                    default:
                        break
                    }
                case .failure(let error):
                    print("error: ", error.localizedDescription)
                    ViewStore(self.store, observe: { $0 }).send(.loginFail)
                }
            }
        )
        .frame(width: screenSize.width - 40, height: 54)
        .cornerRadius(5)
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
