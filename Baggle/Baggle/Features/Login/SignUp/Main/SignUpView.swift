//
//  SignUpView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import PhotosUI
import SwiftUI

import ComposableArchitecture

struct SignUpView: View {

    let store: StoreOf<SignUpFeature>

    var body: some View {

        NavigationStackStore(self.store.scope(
            state: \.path,
            action: { .path($0)})
        ) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in

                PhotosPicker(
                    selection: viewStore.binding(
                        get: \.imageSelection,
                        send: { item in
                            SignUpFeature.Action.imageChanged(item)
                        }
                    ),
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    ProfileImageView(imageState: viewStore.imageState)
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 160, height: 160)
                        .background {
                            Circle()
                                .tint(Color.gray.opacity(0.2))
                        }
                }

                VStack {
                    Text("닉네임 입력")
                        .font(.largeTitle)

                    NavigationLink(state: SignUpSuccessFeature.State()) {
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
            SignUpSuccessView(store: store)
        }
    }
}

struct SignUpNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            store: Store(
                initialState: SignUpFeature.State(),
                reducer: SignUpFeature()
            )
        )
    }
}
