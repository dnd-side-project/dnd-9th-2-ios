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
                CircleProfileView(imageUrl: feed.userImageURL, size: .small)

                Text(feed.username)
                    .baggleTypoLineSpacing(size: 16, weight: .bold)
                    .foregroundColor(.gray14)

                Spacer()

                Button {
                    moreButtonAction()
                } label: {
                    Image.Icon.more
                }
            }
            .foregroundColor(.black)

            AsyncImage(url: URL(string: feed.feedImageURL)) { image in
                image
                    .resizable()
            } placeholder: {
                Color.gray
            }
            .aspectRatio(1.0, contentMode: .fill)
            .cornerRadius(12)
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
