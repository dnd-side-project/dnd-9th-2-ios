//
//  CreateMeetingMemoView.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

struct CreateMemoView: View {

    let store: StoreOf<CreateMemoFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 16) {

                NumberListView(data: CreateStatus.array, selectedStatus: .memo)

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
}

struct CreateMeetingMemoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMemoView(
            store: Store(
                initialState: CreateMemoFeature.State(),
                reducer: CreateMemoFeature()
            )
        )
    }
}
