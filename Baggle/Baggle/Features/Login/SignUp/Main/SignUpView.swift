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

    private typealias SignUpViewStore = ViewStore<SignUpFeature.State, SignUpFeature.Action>

    let store: StoreOf<SignUpFeature>

    var body: some View {

        NavigationStackStore(self.store.scope(
            state: \.path,
            action: { .path($0)})
        ) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in

                ZStack {

                    loadingView(viewStore: viewStore)
                        .background(.gray.opacity(0.4))
                        .zIndex(10)

                    VStack {

                        ScrollView {

                            VStack {
                                description

                                Spacer()

                                photoPicker(viewStore: viewStore)
                                    .padding()

                                nicknameTextField(viewStore: viewStore)

                                Spacer()
                                Spacer()
                                Spacer()
                            }
                            .padding()
                        }

                        nextButton(viewStore: viewStore)
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
            .onTapGesture {
                hideKeyboard()
            }
        } destination: { store in
            SignUpSuccessView(store: store)
        }
    }
}

extension SignUpView {

    @ViewBuilder
    private func loadingView(viewStore: SignUpViewStore) -> some View {
        if viewStore.isLoading {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var description: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("안녕하세요!")

                Text("Baggle에서 쓸 프로필을")

                Text("설정해주세요.")
            }
            .font(.title)

            Spacer()
        }
    }

    @ViewBuilder
    private func photoPicker(viewStore: SignUpViewStore) -> some View {
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
    }

    @ViewBuilder
    private func nicknameTextField(viewStore: SignUpViewStore) -> some View {
        BaggleTextField(
            text: viewStore.binding(
                get: \.nickname,
                send: SignUpFeature.Action.nicknameChanged
            ),
            state: viewStore.binding(
                get: \.textfieldState,
                send: SignUpFeature.Action.textfieldStateChanged
            ),
            placeholder: "닉네임 (한, 영, 숫자, _, -, 2-8자)",
            maxCount: 8
        )
    }

    @ViewBuilder
    private func nextButton(viewStore: SignUpViewStore) -> some View {
        Button {
            viewStore.send(.nextButtonTapped)
        } label: {
            Text("다음")
        }
        .buttonStyle(BagglePrimaryStyle())
        .padding(.horizontal)
        .padding(.bottom)
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
