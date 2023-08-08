//
//  BadgeView.swift
//  Baggle
//
//  Created by youtak on 2023/08/08.
//

import SwiftUI

struct BadgeView: View {

    let text: String
    let foregroundColor: Color
    let backgroundColor: Color

    var body: some View {
        Text(text)
            .font(.system(size: 16).bold())
            .padding(.vertical, 8)
            .padding(.horizontal)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(50)
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView(text: "가입축하", foregroundColor: .white, backgroundColor: .baggleRed)
    }
}
