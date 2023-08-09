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
    let imageURL: String
    let closeButtonAction: () -> Void

    var body: some View {
        ZStack {
            ShadeView(isPresented: $isPresented)

            if isPresented {
                VStack(spacing: 16) {
                    KFImage(URL(string: imageURL))
                        .placeholder { _ in
                            Color.grayF5
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenSize.width - 40, height: screenSize.width - 40)
                        .cornerRadius(12)
                        .padding(.top, 70) // 이미지 기준 가운데 정렬 맞추기 위해 버튼 크기만큼 상단 패딩 추가

                    Button("닫기") {
                        closeButtonAction()
                    }
                    .buttonStyle(BaggleTertiaryStyle())
                }
            }
        }
//        .onAppear { isPresented = true }
//        .onDisappear { isPresented = false }
    }
}
