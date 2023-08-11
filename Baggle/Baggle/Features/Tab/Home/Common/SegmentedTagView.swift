//
//  SegmentedTagView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/04.
//

import SwiftUI

struct SegmentedTagView: View {
    let title: String
    let count: Int
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.Baggle.body1)
                .foregroundColor(.gray11)

            CircleNumberView(number: "\(count)", isSelected: true)
        }
        .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 16))
        .background(Color.white)
        .opacity(isSelected ? 1 : 0.5)
        .cornerRadius(12, corners: [.topLeft, .topRight])
    }
}

struct SegmentedTagView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedTagView(title: "예정된 약속", count: 10, isSelected: true)
            .previewLayout(.sizeThatFits)

        SegmentedTagView(title: "지난 약속", count: 10, isSelected: false)
            .previewLayout(.sizeThatFits)
    }
}
