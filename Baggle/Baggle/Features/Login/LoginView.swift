//
//  LoginView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

import ComposableArchitecture

struct LoginView: View {

    typealias LoginViewStore = ViewStore<LoginFeature.State, LoginFeature.Action>

    let store: StoreOf<LoginFeature>

    @State var loginButtonState: ButtonState = .enable

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack {

                Spacer()

                Circle()
                    .fill(Color.blue)
                    .frame(width: 200, height: 200)
                    .padding()

                Spacer()

                Button("테스트용") {
                    loginButtonState = (loginButtonState == .disable) ? .enable : .disable
                }

                loginButton()
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

    func loginButton() -> some View {
        BaggleButton(action: {
            ViewStore(self.store).send(.kakaoLoginButtonTapped)
        }, label: {
            Text("로그인")
        }, state: $loginButtonState)
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
