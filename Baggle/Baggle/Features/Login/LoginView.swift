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
                        
                        description(viewStore: viewStore)
                    }
                    .padding(.bottom, 16)
                    .transition(.opacity.animation(.easeIn(duration: Const.Animation.loginButton)))
                }
            }
            .fullScreenCover(store: self.store.scope(
                state: \.$signUpNickname,
                action: { .signUpNickname($0) })
            ) { signupStore in
                SignUpView(store: signupStore)
            }
            .fullScreenCover(store: self.store.scope(
                state: \.$onboardingState,
                action: { .onboardingAction($0) })
            ) { store in
                OnboardingView(store: store)
            }
            .baggleAlert(
                isPresented: viewStore.binding(
                    get: { $0.isAlertPresented },
                    send: { LoginFeature.Action.presentAlert($0) }
                ),
                alertType: viewStore.alertType,
                action: { viewStore.send(.alertButtonTapped) }
            )
            .fullScreenCover(
                isPresented: viewStore.binding(
                    get: \.presentSafariView,
                    send: { _ in LoginFeature.Action.presentSafariView }
                )
            ) {
                if let url = URL(string: viewStore.state.safariURL) {
                    SafariWebView(url: url)
                }
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
                    ViewStore(self.store, observe: { $0 }).send(.appleLoginFailed)
                }
            }
        )
        .frame(width: screenSize.width - 40, height: 54)
        .cornerRadius(5)
    }
    
    func description(viewStore: LoginViewStore) -> some View {
        HStack(spacing: 0) {
            Text("로그인 시 ")
            
            Text("이용약관")
                .font(.Baggle.caption3)
                .foregroundColor(.primaryNormal)
                .onTapGesture {
                    viewStore.send(.termsOfServiceButtonTapped)
                }
            
            Text("과 ")
            
            Text("개인정보 처리 방침")
                .font(.Baggle.caption3)
                .foregroundColor(.primaryNormal)
                .onTapGesture {
                    viewStore.send(.privacyPolicyButtonTapped)
                }
            
            Text("에 동의하게 됩니다.")
        }
        .font(.Baggle.caption4)
        .foregroundColor(.gray7)
        .padding(.top, 4)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: Store(
                initialState: LoginFeature.State(completeSplashAnimation: true),
                reducer: LoginFeature()._printChanges()
            )
        )
    }
}
