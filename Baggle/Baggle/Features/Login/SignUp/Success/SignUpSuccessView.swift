//
//  SignUpProfileImageView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import SwiftUI

import ComposableArchitecture

struct SignUpSuccessView: View {

    let store: StoreOf<SignUpSuccessFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack {
                description

                Spacer()

                Button {
                    viewStore.send(.nextButtonTapped)
                } label: {
                    Text("완료")
                        .padding()
                }
                .buttonStyle(BagglePrimaryStyle())
            }
            .navigationBarBackButtonHidden()
        }
    }
}

extension SignUpSuccessView {

    @ViewBuilder
    private var description: some View {
        VStack(spacing: 8) {
            Text("Welcome")

            Text("To")

            Text("Baggle")
        }
        .font(.title)
    }
}

struct SignUpProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpSuccessView(
                store: Store(
                    initialState: SignUpSuccessFeature.State(),
                    reducer: SignUpSuccessFeature()
                )
            )
        }
    }
}
