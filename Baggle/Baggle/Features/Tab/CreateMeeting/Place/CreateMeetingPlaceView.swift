//
//  CreateMeetingPlaceView.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

struct CreateMeetingPlaceView: View {

    let store: StoreOf<CreateMeetingPlaceFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("장소를 정하세요")
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

struct CreateMeetingPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMeetingPlaceView(
            store: Store(
                initialState: CreateMeetingPlaceFeature.State(),
                reducer: CreateMeetingPlaceFeature()
            )
        )
    }
}
