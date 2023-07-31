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
                    Text("제목을 정하세요")
                        .font(.largeTitle)

                    Spacer()

                    Button {
                        viewStore.send(.nextButtonTapped)
                    } label: {
                        Text("다음")
                    }
                    .buttonStyle(BagglePrimaryStyle())
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("취소") {
                            viewStore.send(.cancelButtonTapped)
                        }
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
