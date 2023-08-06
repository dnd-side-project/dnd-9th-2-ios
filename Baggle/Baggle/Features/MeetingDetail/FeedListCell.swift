//
//  FeedListCell.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/07.
//

import SwiftUI

struct FeedListCell: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    CircleProfileView(imageUrl: "", size: .small)

                    Text("수빈")
                        .font(.system(size: 16, weight: .bold))

                    Spacer()

                    Button {
                        print("더보기")
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
                .foregroundColor(.black)

                AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/81167570?v=4")) { image in
                    image
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .cornerRadius(12)
                } placeholder: {
                    Color.gray
                }
                .clipped()
            }
        }
    }
}

struct FeedListCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedListCell()
            .padding(20)
            .previewLayout(.sizeThatFits)
    }
}
