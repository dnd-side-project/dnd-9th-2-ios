//
//  FeedListCell.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/07.
//

import SwiftUI

struct FeedListCell: View {
    let feed: Feed
    let moreButtonAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                CircleProfileView(imageUrl: "", size: .small)

                Text(feed.username)
                    .font(.system(size: 16, weight: .bold))

                Spacer()

                Button {
                    moreButtonAction()
                } label: {
                    Image.Icon.more
                }
            }
            .foregroundColor(.gray14)

            // swiftlint:disable:next line_length
            AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/81167570?v=4")) { image in
                image
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fill)
                    .cornerRadius(12)
            } placeholder: {
                Color.grayF5
            }
            .clipped()
        }
    }
}

struct FeedListCell_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next line_length
        FeedListCell(feed: Feed(id: 0, userId: 1, username: "수빈", userImageURL: "", feedImageURL: ""),
                     moreButtonAction: { print("더보기" )})
            .padding(20)
            .previewLayout(.sizeThatFits)
    }
}
