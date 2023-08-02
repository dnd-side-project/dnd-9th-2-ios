//
//  BaggleTimePickerView.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct BaggleTimePickerView: View {

    @Binding var date: Date

    var body: some View {
        DatePicker(
            "",
            selection: $date,
            displayedComponents: .hourAndMinute
        )
        .labelsHidden()
        .datePickerStyle(.wheel)
        .environment(\.locale, Locale.init(identifier: "KO"))
    }
}

struct BaggleTimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        BaggleTimePickerView(
            date: .constant(Date())
        )
    }
}
