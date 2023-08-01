//
//  NumberListView.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

struct NumberListView: View {

    let data: [String]
    let selectedStatus: CreateStatus

    var body: some View {
        HStack {
            ForEach(data.indices, id: \.self) { index in
                CircleNumberView(number: data[index], isSelected: index == selectedStatus.index)
            }
        }
    }
}

struct NumberListView_Previews: PreviewProvider {
    static var previews: some View {
        NumberListView(data: CreateStatus.array, selectedStatus: .title)
            .previewLayout(.sizeThatFits)
    }
}
