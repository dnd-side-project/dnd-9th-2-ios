//
//  MeetingDetailView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

struct MeetingDetailView: View {

    let store: StoreOf<MeetingDetailFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Text("모임 생성")
                    .font(.title)

                if let data = viewStore.meetingData {
                    Text("모임명: \(data.name), 모임 id: \(data.id)")
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct MeetingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDetailView(
            store: Store(
                initialState: MeetingDetailFeature.State(),
                reducer: MeetingDetailFeature(meetingId: 1)
            )
        )
    }
}
