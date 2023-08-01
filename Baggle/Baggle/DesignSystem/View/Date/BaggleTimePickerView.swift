//
//  BaggleTimePickerView.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct BaggleTimePickerView: View {

    let store: StoreOf<BaggleDatePickerFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            DatePicker(
                "",
                selection: viewStore.binding(
                    get: \.date,
                    send: BaggleDatePickerFeature.Action.dateChanged
                ),
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .datePickerStyle(.wheel)
            .environment(\.locale, Locale.init(identifier: "KO"))
        }
    }
}

struct BaggleTimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        BaggleTimePickerView(
            store: Store(
                initialState: BaggleDatePickerFeature.State(),
                reducer: BaggleDatePickerFeature()
            )
        )
    }
}
