//
//  LoginView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

import ComposableArchitecture

struct LoginView: View {

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

                Button {
                    viewStore.send(.kakaoLoginButtonTapped)
                } label: {
                    HStack {

                        Spacer()

                        Text("로그인")
                            .font(.title)
                            .padding()

                        Spacer()
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)

                Spacer()
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: Store(
                initialState: LoginFeature.State(),
                reducer: LoginFeature()
            )
        )
    }
}
