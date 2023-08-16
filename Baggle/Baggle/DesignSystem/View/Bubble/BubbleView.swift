//
//  BubbleView.swift
//  Baggle
//
//  Created by youtak on 2023/08/03.
//

import SwiftUI

struct BubbleView: View {

    let size: BubbleSize
    let color: BubbleColor
    let text: String

    var body: some View {
        VStack(spacing: -3) {
            Text(text)
                .font(.Baggle.caption2)
                .foregroundColor(color.foregroundColor)
                .padding(.vertical, size.paddingVertical)
                .padding(.horizontal, size.paddingHorizontal)
                .background(color.backgroundColor)
                .cornerRadius(50)

            RoundedTriangle(radius: 2)
                .fill(color.backgroundColor)
                .frame(width: 15, height: 12)
        }
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(size: .small, color: .primary, text: "최대 6명")
            .previewLayout(.sizeThatFits)
    }
}
