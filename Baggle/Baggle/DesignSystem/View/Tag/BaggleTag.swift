//
//  BaggleTag.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/24.
//

import SwiftUI

struct BaggleTag: View {
    private var text: String
    private var color: BaggleColor

    init(_ text: String, _ color: BaggleColor = .blue) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .kerning(-0.5)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .foregroundColor(color.fgColor)
            .background(color.bgColor)
            .cornerRadius(6)
    }
}

struct BaggleTag_Previews: PreviewProvider {
    static var previews: some View {
        BaggleTag("장소")

        BaggleTag("시간", .pink)
    }
}
