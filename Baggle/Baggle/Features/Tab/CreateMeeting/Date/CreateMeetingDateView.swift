//
//  CreateMeetingDateView.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

struct CreateMeetingDateView: View {

    let store: StoreOf<CreateMeetingDateFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("날짜를 정하세요")
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

struct CreateMeetingDateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMeetingDateView(
            store: Store(
                initialState: CreateMeetingDateFeature.State(),
                reducer: CreateMeetingDateFeature()
            )
        )
    }
}
