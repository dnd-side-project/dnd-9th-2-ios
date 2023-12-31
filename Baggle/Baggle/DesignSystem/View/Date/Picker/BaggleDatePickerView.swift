//
//  BaggleDatePickerView.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct BaggleDatePickerView: View {

    @Binding var date: Date

    let tenYearsFromNow = Date.now().addingTimeInterval(10 * 365 * 24 * 60 * 60)

    var body: some View {
        DatePicker(
            "",
            selection: $date,
            in: Date.now()...tenYearsFromNow,
            displayedComponents: .date
        )
        .labelsHidden()
        .datePickerStyle(.wheel)
    }
}

struct BaggleDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        BaggleDatePickerView(
            date: .constant(Date())
        )
    }
}
