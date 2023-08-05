//
//  TimerView.swift
//  Baggle
//
//  Created by youtak on 2023/08/05.
//

import SwiftUI

import ComposableArchitecture

struct SmallTimerView: View {

    let store: StoreOf<TimerFeature>
    let minute: String = "5"
    let second: String = "00"

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(spacing: 1) {
                Text(minute)
                Text(":")
                Text(second)
            }
            .font(.system(size: 15).bold())
            .padding(.bottom, 4)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(20)
        }
    }
}

struct SmallTimerView_Previews: PreviewProvider {
    static var previews: some View {
        SmallTimerView(
            store: Store(
                initialState: TimerFeature.State(),
                reducer: TimerFeature()
            )
        )
    }
}
