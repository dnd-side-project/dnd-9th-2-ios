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

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Text("모임 참여")

                Button("나가기") {
                    dismiss()
                }

                Button("모임 참여하기") {
                    viewStore.send(.joinButtonTapped)
                }
            }
        }
    }
}

struct JoinMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        JoinMeetingView(
            store: Store(
                initialState: JoinMeetingFeature.State(),
                reducer: JoinMeetingFeature(meetingId: 100)
            )
        )
    }
}
