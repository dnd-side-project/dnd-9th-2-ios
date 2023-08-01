//
//  JoinMeetingView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct JoinMeetingView: View {

    let store: StoreOf<JoinMeetingFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Text("모임 참여")

                Text("id: \(viewStore.meetingId)")

                Button("모임 참여하기") {
                    viewStore.send(.joinButtonTapped)
                }
                .buttonStyle(BagglePrimaryStyle())

                Button("나중에 참여하기") {
                    viewStore.send(.exitButtonTapped)
                }
            }
        }
    }
}

struct JoinMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        JoinMeetingView(
            store: Store(
                initialState: JoinMeetingFeature.State(meetingId: 100),
                reducer: JoinMeetingFeature()
            )
        )
    }
}
