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
    let isBlocked: Bool
    let closeButtonAction: () -> Void

    var body: some View {
        ZStack {
            ShadeView(isPresented: $isPresented)

            VStack(spacing: 16) {
                
                ZStack {
                    KFImage(URL(string: imageURL))
                        .placeholder { _ in
                            Color.gray2
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenSize.width - 40, height: screenSize.width - 40)
                        .blur(radius: isBlocked ? 40 : 0, opaque: true)
                        .cornerRadius(12)
                    
                    if isBlocked {
                        Text("신고가 접수된 게시글입니다.\n확인 후 24시간 내에 처리될 예정입니다.")
                            .multilineTextAlignment(.center)
                            .fontWithLineSpacing(fontType: .body2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(.black)
                            .cornerRadius(12)
                    }
                }
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
