//
//  CreateMeetingView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/24.
//

import SwiftUI

import ComposableArchitecture

struct CreateMeetingView: View {

    let store: StoreOf<CreateMeetingFeature>

    var body: some View {

        NavigationStack {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Text("모임 생성")
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("취소") {
                            viewStore.send(.cancelButtonTapped)
                        }
                    }
                }
            }
        }
    }
}

struct CreateMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMeetingView(
            store: Store(
                initialState: CreateMeetingFeature.State(),
                reducer: CreateMeetingFeature()
            )
        )
    }
}
