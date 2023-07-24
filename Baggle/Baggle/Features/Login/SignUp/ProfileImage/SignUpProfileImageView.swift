//
//  SignUpProfileImageView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import SwiftUI

import ComposableArchitecture

struct SignUpProfileImageView: View {

    let store: StoreOf<SignUpProfileImageFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack {
                Text("프로필 이미지 설정")
                    .font(.largeTitle)

                Circle()
                    .fill(Color.gray)
                    .frame(width: 200, height: 200)
                    .padding()

                Button {
                    viewStore.send(.nextButtonTapped)
                } label: {
                    Text("다음")
                        .padding()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct SignUpProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpProfileImageView(
                store: Store(
                    initialState: SignUpProfileImageFeature.State(),
                    reducer: SignUpProfileImageFeature()
                )
            )
        }
    }
}
