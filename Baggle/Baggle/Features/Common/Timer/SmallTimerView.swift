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
    let numberWidth: CGFloat = 10

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(alignment: .bottom, spacing: 0) {
                Text("\(viewStore.timerCount.minutes)")
                    .frame(width: numberWidth)
                Text(":")
                Text("\(viewStore.timerCount.seconds.tenDigit)")
                    .frame(width: numberWidth)
                Text("\(viewStore.timerCount.seconds.oneDigit)")
                    .frame(width: numberWidth)
            }
            .font(.system(size: 15).bold())
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .foregroundColor(Color.white)
            .background(Color.primaryNormal)
            .cornerRadius(20)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct SmallTimerView_Previews: PreviewProvider {
    static var previews: some View {
        SmallTimerView(
            store: Store(
                initialState: TimerFeature.State(timerCount: 30),
                reducer: TimerFeature()
            )
        )
    }
}
