//
//  FeedListCell.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/07.
//

import SwiftUI

import Kingfisher

struct FeedListCell: View {

    let feed: Feed
    let moreButtonAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                CircleProfileView(imageUrl: feed.userImageURL, size: .small)

                Text(feed.username)
                    .font(.Baggle.body2)
                    .foregroundColor(.gray11)

                Spacer()

                Button {
                    moreButtonAction()
                } label: {
                    Image.Icon.more
                }
            }

            ZStack {
                KFImage(URL(string: feed.feedImageURL))
                    .placeholder({ _ in
                        Color.gray2
                    })
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fill)
                    .blur(radius: feed.isReport ? 40 : 0, opaque: true)
                    .cornerRadius(12)
                    .clipped()
                
                if feed.isReport {
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
        }
    }
}

struct FeedListCell_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next line_length
        FeedListCell(feed: Feed(id: 0, userID: 1, username: "수빈", userImageURL: "", feedImageURL: "", isReport: false),
                     moreButtonAction: { print("더보기" )})
            .padding(20)
            .previewLayout(.sizeThatFits)
    }
}
