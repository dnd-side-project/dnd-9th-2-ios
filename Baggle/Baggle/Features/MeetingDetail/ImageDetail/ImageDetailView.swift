//
//  ImageDetailView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/08.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct ImageDetailView: View {

    @Binding var isPresented: Bool
    @State var isAnimating: Bool = false

    let imageURL: String
    let closeButtonAction: () -> Void

    var body: some View {
        ZStack {
            ShadeView(isPresented: $isPresented)

            VStack(spacing: 16) {
                KFImage(URL(string: imageURL))
                    .placeholder { _ in
                        Color.gray2
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenSize.width - 40, height: screenSize.width - 40)
                    .cornerRadius(12)
                    .padding(.top, 70)

                Button("닫기") {
                    closeButtonAction()
                }
                .buttonStyle(BaggleTertiaryStyle())
            }
            .opacity(isAnimating ? 1 : 0)
            .animation(.easeInOut(duration: 0.2), value: isAnimating)
        }
        .onAppear { isAnimating = true }
        .onDisappear { isAnimating = false }
    }
}
