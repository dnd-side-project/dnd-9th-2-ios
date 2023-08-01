//
//  NumberListView.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

struct NumberListView: View {

    let data: [String]
    let selectedIndex: Int

    var body: some View {
        HStack {
            ForEach(data.indices, id: \.self) { index in
                CircleNumberView(number: data[index], isSelected: index == selectedIndex)
            }
        }
    }
}

struct NumberListView_Previews: PreviewProvider {
    static var previews: some View {
        NumberListView(data: ["1", "2", "3", "4"], selectedIndex: 0)
            .previewLayout(.sizeThatFits)
    }
}
