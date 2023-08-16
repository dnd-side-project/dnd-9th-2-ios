//
//  FeedPhotoEntity.swift
//  Baggle
//
//  Created by youtak on 2023/08/16.
//

import Foundation

struct FeedPhotoEntity: Decodable {
    let feedID: Int
    let feedImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case feedID = "feedId"
        case feedImageURL = "feedUrl"
    }
}

extension FeedPhotoEntity {
    func toDomain(feedUser: FeedUser) -> Feed {
        Feed(
            id: self.feedID,
            userID: feedUser.id,
            username: feedUser.name,
            userImageURL: feedUser.profileImageURL,
            feedImageURL: self.feedImageURL
        )
    }
}

