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
    
    // 긴급 이미지 인증 이후 피드 모델 업데이트
    func toDomain(feedUser: FeedUser) -> Feed {
        Feed(
            id: self.feedID,
            userID: feedUser.id,
            username: feedUser.name,
            userImageURL: feedUser.profileImageURL,
            feedImageURL: self.feedImageURL,
            isReport: false // 이미지 업데이트 후 항상 신고하기 전임
        )
    }
}
