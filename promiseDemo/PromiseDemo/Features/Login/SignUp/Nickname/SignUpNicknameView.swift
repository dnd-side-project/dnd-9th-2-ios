//
//  SignUpView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import SwiftUI

import ComposableArchitecture

struct SignUpNicknameView: View {

    let store: StoreOf<SignUpNicknameFeature>

    var body: some View {

        NavigationStackStore(self.store.scope(
            state: \.path,
            action: { .path($0)})
        ) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in

                VStack {
                    Text("닉네임 입력")
                        .font(.largeTitle)

                    NavigationLink(state: SignUpProfileImageFeature.State()) {
                        Text("다음")
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                    }
                    .transaction { transaction in
                        transaction.disablesAnimations = viewStore.disableDismissAnimation
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("취소") {
                            viewStore.send(.cancelButtonTapped)
                        }
                    }
                }
            }
        } destination: { store in
            SignUpProfileImageView(store: store)
        }
    }
}

struct SignUpNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNicknameView(
            store: Store(
                initialState: SignUpNicknameFeature.State(),
                reducer: SignUpNicknameFeature()
            )
        )
    }
}
