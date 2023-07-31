//
//  CreateMeetingView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/24.
//

import SwiftUI

import ComposableArchitecture

struct CreateMeetingTitleView: View {

    let store: StoreOf<CreateMeetingTitleFeature>

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
                    /CreateMeetingTitleFeature.Child.State.meetingPlace,
                    action: CreateMeetingTitleFeature.Child.Action.meetingPlace
                ) { store in
                    CreateMeetingPlaceView(store: store)
                }
            case .meetingDate:
                CaseLet(
                    /CreateMeetingTitleFeature.Child.State.meetingDate,
                    action: CreateMeetingTitleFeature.Child.Action.meetingDate
                ) { store in
                    CreateMeetingDateView(store: store)
                }
            case .meetingMemo:
                CaseLet(
                    /CreateMeetingTitleFeature.Child.State.meetingMemo,
                    action: CreateMeetingTitleFeature.Child.Action.meetingMemo
                ) { store in
                    CreateMeetingMemoView(store: store)
                }
            case .createSuccess:
                CaseLet(
                    /CreateMeetingTitleFeature.Child.State.createSuccess,
                    action: CreateMeetingTitleFeature.Child.Action.createSuccess
                ) { store in
                    CreateMeetingSuccessView(store: store)
                }
            }
        }
    }
}

struct CreateMeetingTitleView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMeetingTitleView(
            store: Store(
                initialState: CreateMeetingTitleFeature.State(),
                reducer: CreateMeetingTitleFeature()
            )
        )
    }
}
