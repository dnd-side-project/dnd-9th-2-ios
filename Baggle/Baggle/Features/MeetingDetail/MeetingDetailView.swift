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

        WithViewStore(self.store, observe: { $0 }) { _ in
            VStack {
                Text("모임 생성")
            }
        }
    }
}

struct MeetingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDetailView(
            store: Store(
                initialState: MeetingDetailFeature.State(),
                reducer: MeetingDetailFeature()
            )
        )
    }
}
