//
//  MeetingEditView.swift
//  Baggle
//
//  Created by youtak on 2023/08/31.
//

import SwiftUI

import ComposableArchitecture

struct MeetingEditView: View {

    let store: StoreOf<MeetingEditFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Hello, World")
        }
    }
}

struct MeetingEditView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingEditView(
            store: Store(
                initialState: MeetingEditFeature.State(),
                reducer: MeetingEditFeature()
            )
        )
    }
}
