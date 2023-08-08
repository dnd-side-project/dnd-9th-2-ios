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
    let color: TimerColor
    let numberWidth: CGFloat = 18
    let deadline: Int = 10

    init(store: StoreOf<TimerFeature>, color: TimerColor = .white) {
        self.store = store
        self.color = color
    }

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            HStack(alignment: .bottom, spacing: 0) {

                if viewStore.isTimerOver {
                    Text("TIMEOUT")
                } else {
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
            }
            .font(.system(size: 28).bold())
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .foregroundColor(color.foregroundColor)
            .background(viewStore.timerCount <= 10 ? Color.red : color.backgroundColor)
            .cornerRadius(12)
            .animation(.easeInOut(duration: 0.3), value: viewStore.isTimerOver)
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
