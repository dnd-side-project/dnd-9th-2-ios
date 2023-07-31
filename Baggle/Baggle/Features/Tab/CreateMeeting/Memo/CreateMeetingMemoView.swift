//
//  CreateMeetingMemoView.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

struct CreateMeetingMemoView: View {

    let store: StoreOf<CreateMeetingMemoFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("메모를 입력하세요")
                .font(.largeTitle)

            Spacer()

            Button {
                viewStore.send(.nextButtonTapped)
            } label: {
                Text("다음")
            }
            .buttonStyle(BagglePrimaryStyle())
        }
    }
}

struct CreateMeetingMemoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMeetingMemoView(
            store: Store(
                initialState: CreateMeetingMemoFeature.State(),
                reducer: CreateMeetingMemoFeature()
            )
        )
    }
}
