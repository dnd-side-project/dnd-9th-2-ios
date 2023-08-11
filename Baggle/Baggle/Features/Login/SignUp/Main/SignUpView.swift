//
//  SignUpView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import Combine
import PhotosUI
import SwiftUI

import ComposableArchitecture

struct SignUpView: View {

    private typealias SignUpViewStore = ViewStore<SignUpFeature.State, SignUpFeature.Action>

    let store: StoreOf<SignUpFeature>
    let scrollBottomID: String = "scrollBottomID"

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

                        ScrollViewReader { scrollProxy in
                            ScrollView {

                                VStack {
                                    description

                                    photoPicker(viewStore: viewStore)

                                    nicknameTextField(viewStore: viewStore)
                                        .id(scrollBottomID)
                                }
                                .padding()
                            }
                            .onChange(of: viewStore.keyboardAppear) { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        scrollProxy.scrollTo(scrollBottomID)
                                    }
                                }
                            }
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
                Text("Baggle에서 쓸 프로필을")

                Text("설정해주세요.")
            }
            .font(.title)

            Spacer()
        }
        .padding(.vertical, 12)
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
        }
        .padding(.top, 40)
    }

    @ViewBuilder
    private func nicknameTextField(viewStore: SignUpViewStore) -> some View {

        BaggleTextField(
            store: self.store.scope(
                state: \.nickNameTextFieldState,
                action: SignUpFeature.Action.textFieldAction
            ),
            placeholder: "닉네임 (한, 영, 숫자, _, -, 2-8자)"
        )
        .padding(.vertical, 50)
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
        .disabled(viewStore.disableButton)
    }
}

struct SignUpNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            store: Store(
                initialState: SignUpFeature.State(loginPlatform: .apple, socialLoginToken: "-"),
                reducer: SignUpFeature()
            )
        )
    }
}
