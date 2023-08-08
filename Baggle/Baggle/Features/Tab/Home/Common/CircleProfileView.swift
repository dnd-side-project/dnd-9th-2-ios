//
//  CircleProfileView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/06.
//

import SwiftUI

import Kingfisher

enum ProfileSize {
    case large // 홈, 본인 프로필 이미지
    case medium // 모임 상세, 멤버 프로필 이미지 -> 추가 수정 필요
    case small // 모임 상세, 피드 게시물 위 프로필 이미지
    case extraSmall // 홈, 모임 리스트 내 멤버 프로필 이미지

    var length: CGFloat {
        switch self {
        case .large: return 72
        case .medium: return 64
        case .extraSmall: return 24
        case .small: return 32
        }
    }

    var borderColor: Color {
        switch self {
        case .large: return .grayD9
        case .medium: return .primaryNormal
        case .extraSmall: return .grayBF
        case .small: return .clear
        }
    }
}

struct CircleProfileView: View {
    let imageUrl: String
    let size: ProfileSize
    let hasStroke: Bool

    init(
        imageUrl: String,
        size: ProfileSize,
        hasStroke: Bool = true
    ) {
        self.imageUrl = imageUrl
        self.size = size
        self.hasStroke = hasStroke
    }

    var body: some View {

        KFImage(URL(string: imageUrl))
            .placeholder { _ in
                Image.Profile.profilDefault
                    .resizable()
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.length, height: size.length)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(hasStroke ? size.borderColor : .clear,
                            lineWidth: size == .medium ? 3 : 1)
            }
    }
}

struct CircleProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProfileView(imageUrl: "https://avatars.githubusercontent.com/u/81167570?v=4",
                          size: .large)
            .previewLayout(.sizeThatFits)
    }
}
