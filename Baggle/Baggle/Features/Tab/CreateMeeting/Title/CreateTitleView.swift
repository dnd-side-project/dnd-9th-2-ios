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
                VStack {
                    VStack(alignment: .leading, spacing: 16) {

                        PageIndicator(data: CreateStatus.data, selectedStatus: .title)

                        Text("친구들과 약속을 잡아보세요!")
                            .font(.title2)

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
                    }
                    .padding()

                    Spacer()

                    Button {
                        viewStore.send(.nextButtonTapped)
                    } label: {
                        Text("다음")
                    }
                    .padding(.bottom, 10)
                    .buttonStyle(BagglePrimaryStyle())
                    .disabled(viewStore.state.nextButtonDisabled)
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("취소") {
                            viewStore.send(.cancelButtonTapped)
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }
                .onOpenURL { url in
                    if let id = url.params()?["id"] as? String {
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
