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
    @State var isPresented: Bool = false

    var body: some View {
        ZStack {
            ShadeView(isPresented: $isPresented)

            VStack(spacing: 16) {
                KFImage(URL(string: ""))
                    .placeholder { _ in
                        Color.grayF5
                    }
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fill)
                    .cornerRadius(12)
                    .clipped()
                    .frame(width: screenSize.width - 40, height: screenSize.width - 40)
                    .padding(.top, 70) // 이미지 기준 가운데 정렬 맞추기 위해 버튼 크기만큼 상단 패딩 추가

                Button("닫기") {
                    print("닫기")
                }
                .buttonStyle(BaggleTertiaryStyle())
            }
        }
        .onAppear { isPresented = true }
        .onDisappear { isPresented = false }
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView()
            .previewLayout(.sizeThatFits)
    }
}
