//
//  BubbleView.swift
//  Baggle
//
//  Created by youtak on 2023/08/03.
//

import SwiftUI

struct BubbleView: View {

    let text: String

    var body: some View {
        ZStack(alignment: .bottom) {
            Text(text)
                .foregroundColor(Color.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(Color.blue)
                .cornerRadius(50)
            
            RoundedTriangle(radius: 2)
                .fill(Color.blue)
                .frame(width: 15, height: 12)
                .offset(x: 0, y: 9)
        }
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(text: "최대 6명")
            .previewLayout(.sizeThatFits)
    }
}
