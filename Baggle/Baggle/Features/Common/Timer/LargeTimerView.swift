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
    let numberWidth: CGFloat = 17

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(alignment: .bottom, spacing: 0) {
                Text("\(viewStore.timerCount.minutes.tenDigit)")
                    .frame(width: numberWidth)
                Text("\(viewStore.timerCount.minutes.oneDigit)")
                    .frame(width: numberWidth)
                Text(":")
                Text("\(viewStore.timerCount.seconds.tenDigit)")
                    .frame(width: numberWidth)
                Text("\(viewStore.timerCount.seconds.oneDigit)")
                    .frame(width: numberWidth)
            }
            .font(.system(size: 28).bold())
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(12)
            .onAppear {
                viewStore.send(.onAppear)
            }
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
