//
//  BaggleDatePickerView.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct BaggleDatePickerView: View {

    let store: StoreOf<BaggleDatePickerFeature>
    let tenYearsFromNow = Date().addingTimeInterval(10 * 365 * 24 * 60 * 60)

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            DatePicker(
                "",
                selection: viewStore.binding(
                    get: \.date,
                    send: BaggleDatePickerFeature.Action.dateChanged
                ),
                in: Date()...tenYearsFromNow,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(.wheel)
            .environment(\.locale, Locale.init(identifier: "KO"))
        }
    }
}

struct BaggleDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        BaggleDatePickerView(
            store: Store(
                initialState: BaggleDatePickerFeature.State(),
                reducer: BaggleDatePickerFeature()
            )
        )
    }
}
