//
//  CircleProfileView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/06.
//

import SwiftUI

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
        case .large: return .gray
        case .medium: return .blue
        case .extraSmall: return .gray
        case .small: return .clear
        }
    }
}

struct CircleProfileView: View {

    let imageUrl: String
    let size: ProfileSize
    var isFailed: Bool = false

    var body: some View {

        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Color.grayF5
        }
        .frame(width: size.length, height: size.length)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(size.borderColor, lineWidth: size == .medium ? 3 : 1)

            if isFailed {
                Circle()
                    .fill(Color.gray1F.opacity(0.7))

                BaggleStamp(status: .fail)
            }
        }
    }
}

struct CircleProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleProfileView(
                imageUrl: "https://avatars.githubusercontent.com/u/81167570?v=4",
                size: .large
            )

            CircleProfileView(
                imageUrl: "https://avatars.githubusercontent.com/u/81167570?v=4",
                size: .small,
                isFailed: true
            )
        }
    }
}
