//
//  CreateMeetingView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/24.
//

import SwiftUI

import ComposableArchitecture

struct CreateTitleView: View {

    let store: StoreOf<CreateTitleFeature>

    var body: some View {

        NavigationStackStore(self.store.scope(
            state: \.path,
            action: { .path($0)})
        ) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack(spacing: 0) {

                    CreateDescription(createStatus: .title, title: "친구들과 약속을 잡아보세요!")

                    BaggleTextField(
                        store: self.store.scope(
                            state: \.textFieldState,
                            action: CreateTitleFeature.Action.textFieldAction
                        ),
                        placeholder: "ex. 바글이와 저녁 약속",
                        title: .title("어떤 약속인가요?")
                    )
                    .submitLabel(.done)
                    .onSubmit {
                        viewStore.send(.submitButtonTapped)
                    }

                    Spacer()

                    Button {
                        viewStore.send(.nextButtonTapped)
                    } label: {
                        Text("다음")
                    }
                    .buttonStyle(BagglePrimaryStyle())
                    .disabled(viewStore.state.nextButtonDisabled)
                }
                .padding()
                .touchSpacer()
                .onTapGesture {
                    hideKeyboard()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewStore.send(.backButtonTapped)
                        } label: {
                            Image.Icon.backTail
                        }
                    }
                }
                .onOpenURL { url in
                    if url.params()?["id"] is String {
                        viewStore.send(.cancelButtonTapped)
                    }
                }
            }
        } destination: { pathState in
            switch pathState {
            case .meetingPlace:
                CaseLet(
                    /CreateTitleFeature.Child.State.meetingPlace,
                    action: CreateTitleFeature.Child.Action.meetingPlace
                ) { store in
                    CreatePlaceView(store: store)
                }
            case .meetingDate:
                CaseLet(
                    /CreateTitleFeature.Child.State.meetingDate,
                    action: CreateTitleFeature.Child.Action.meetingDate
                ) { store in
                    CreateDateView(store: store)
                }
            case .meetingMemo:
                CaseLet(
                    /CreateTitleFeature.Child.State.meetingMemo,
                    action: CreateTitleFeature.Child.Action.meetingMemo
                ) { store in
                    CreateMemoView(store: store)
                }
            case .createSuccess:
                CaseLet(
                    /CreateTitleFeature.Child.State.createSuccess,
                    action: CreateTitleFeature.Child.Action.createSuccess
                ) { store in
                    CreateSuccessView(store: store)
                }
            }
        }
    }
}

struct CreateMeetingTitleView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTitleView(
            store: Store(
                initialState: CreateTitleFeature.State(),
                reducer: CreateTitleFeature()
            )
        )
    }
}
