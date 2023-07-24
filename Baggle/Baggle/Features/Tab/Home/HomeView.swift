//
//  HomeView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

struct HomeView: View {
    @State var text: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Home View 입니다")

            Text(attributedFontString(str: "Home View 입니다",
                                      targetStr: "Home View",
                                      font: .body,
                                      targetFont: .headline))

            Text(attributedColorString(str: "Home View 입니다",
                                       targetStr: "Home View",
                                       color: .black,
                                       targetColor: .blue))

            BaggleTextField(text: $text, type: .title("어떤 약속인가요?"), maxCount: 20)
                .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
