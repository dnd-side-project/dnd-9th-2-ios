//
//  TimerView.swift
//  Baggle
//
//  Created by youtak on 2023/08/05.
//

import SwiftUI

import ComposableArchitecture

struct LargeTimerView: View {

    let store: StoreOf<TimerFeature>
    let minute: String = "05"
    let second: String = "00"

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(spacing: 1) {
                Text(minute)
                Text(":")
                Text(second)
            }
            .font(.system(size: 28).bold())
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

struct LargeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        LargeTimerView(
            store: Store(
                initialState: TimerFeature.State(),
                reducer: TimerFeature()
            )
        )
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}
