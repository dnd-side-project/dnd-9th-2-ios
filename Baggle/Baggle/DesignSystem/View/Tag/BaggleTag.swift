//
//  BaggleTag.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/24.
//

import SwiftUI

struct BaggleTag: View {

    private var text: String
    private var color: BaggleTagColor

    init(_ text: String, _ color: BaggleTagColor = .primary) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(.Baggle.caption3)
            .kerning(-0.5)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundColor(.white)
            .background(color.bgColor)
            .cornerRadius(6)
    }
}

struct BaggleTag_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BaggleTag("D-30")

            BaggleTag("D-Day", .red)
        }
    }
}
