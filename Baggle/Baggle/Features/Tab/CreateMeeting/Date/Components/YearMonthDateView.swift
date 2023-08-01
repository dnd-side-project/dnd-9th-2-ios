//
//  YearMonthDateView.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct YearMonthDateView: View {

    let store: StoreOf<YearMonthDateFeature>

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

                BaggleDatePickerView(
                    store: self.store.scope(
                        state: \.baggleDatePicker,
                        action: YearMonthDateFeature.Action.baggleDatePicker
                    )
                )

                Button {
                    viewStore.send(.completeButtonTapped)
                } label: {
                    Text("완료")
                }
                .buttonStyle(BagglePrimaryStyle())
            }
        }
        .padding()
    }
}

struct YearMonthDateView_Previews: PreviewProvider {
    static var previews: some View {
        YearMonthDateView(
            store: Store(
                initialState: YearMonthDateFeature.State(),
                reducer: YearMonthDateFeature()
            )
        )
        .presentationDetents([.height(300)])
    }
}
