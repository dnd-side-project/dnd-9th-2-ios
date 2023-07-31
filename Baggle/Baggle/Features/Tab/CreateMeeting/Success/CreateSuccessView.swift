//
//  CreateMeetingSuccessView.swift
//  Baggle
//
//  Created by youtak on 2023/07/31.
//

import SwiftUI

import ComposableArchitecture

struct CreateSuccessView: View {

    let store: StoreOf<CreateSuccessFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("모임 생성이 완료됐어요!")
                    .font(.largeTitle)

                Spacer()

                Button {
                    viewStore.send(.completeButtonTapped)
                } label: {
                    Text("완료")
                }
                .buttonStyle(BagglePrimaryStyle())
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct CreateMeetingSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSuccessView(
            store: Store(
                initialState: CreateSuccessFeature.State(),
                reducer: CreateSuccessFeature()
            )
        )
    }
}
