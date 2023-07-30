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
                    } label: {
                        NavigationLink(state: CreateMeetingPlaceFeature.State()) {
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    Text("다음")
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
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
        } destination: { store in
            CreateMeetingPlaceView(store: store)
        }
    }
}

struct CreateMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMeetingTitleView(
            store: Store(
                initialState: CreateMeetingTitleFeature.State(),
                reducer: CreateMeetingTitleFeature()
            )
        )
    }
}
