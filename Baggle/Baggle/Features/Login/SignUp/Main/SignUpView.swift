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

                    if viewStore.isLoading {
                        LoadingView()
                    }

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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        scrollProxy.scrollTo(scrollBottomID)
                                    }
                                }
                            }
                        }

                        nextButton(viewStore: viewStore)
                    }
                }
                .baggleAlert(
                    isPresented: viewStore.binding(
                        get: { $0.isAlertPresented },
                        send: { SignUpFeature.Action.presentAlert($0) }
                    ),
                    alertType: viewStore.alertType,
                    action: { viewStore.send(.alertButtonTapped) }
                )
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
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 0) {
                Image.BaggleText.profile
                
                Text("에서 쓸 프로필을")

                Spacer()
            }
            
            Text("설정해주세요.")
        }
        .font(.Baggle.subTitle1)
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
