//
//  BubbleView.swift
//  Baggle
//
//  Created by youtak on 2023/08/03.
//

import SwiftUI

struct BubbleView: View {

    let type: BubbleType
    let text: String

    var body: some View {
        VStack(spacing: -3) {
            Text(text)
                .foregroundColor(type.foregroundColor)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(type.backgroundColor)
                .cornerRadius(50)

            RoundedTriangle(radius: 2)
                .fill(type.backgroundColor)
                .frame(width: 15, height: 12)
        }
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(type: .primary, text: "최대 6명")
            .previewLayout(.sizeThatFits)
    }
}
