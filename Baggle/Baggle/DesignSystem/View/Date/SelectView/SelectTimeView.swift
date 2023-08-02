//
//  HourMinuteView.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct SelectTimeView: View {

    let store: StoreOf<SelectTimeFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 5) {

                HStack {
                    Spacer()

                    Button {
                        viewStore.send(.cancelButtonTapped)
                    } label: {
                        Image(systemName: "xmark")
                            .tint(Color.black)
                    }
                }

                BaggleTimePickerView(
                    store: self.store.scope(
                        state: \.baggleDatePicker,
                        action: SelectTimeFeature.Action.baggleDatePicker
                    )
                )

                Button {
                    viewStore.send(.completeButtonTapped)
                } label: {
                    Text("완료")
                }
                .buttonStyle(BagglePrimaryStyle())
            }
            .padding()
        }
    }
}

struct SelectTimeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTimeView(
            store: Store(
                initialState: SelectTimeFeature.State(),
                reducer: SelectTimeFeature()
            )
        )
    }
}
