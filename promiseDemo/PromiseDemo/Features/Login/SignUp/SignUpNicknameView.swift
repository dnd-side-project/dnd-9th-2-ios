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

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack {
                Text("닉네임 입력")
                    .font(.largeTitle)

                Button {
                    viewStore.send(.moveToNextView)
                } label: {
                    Text("다음")
                        .padding()
                }
                .buttonStyle(.borderedProminent)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        viewStore.send(.cancelButtonTapped)
                    }
                }
            }
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
