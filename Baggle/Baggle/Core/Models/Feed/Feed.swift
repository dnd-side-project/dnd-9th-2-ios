//
//  Feed.swift
//  Baggle
//
//  Created by youtak on 2023/08/10.
//

/// 모임 인증 피드
struct Feed: Equatable {
    let id: Int
    let userID: Int
    let username: String
    let userImageURL: String?
    let feedImageURL: String
    let isReport: Bool
}

extension Feed {
    
    // 신고 이후 업데이트
    func updateAfterReport(reportFeedID: Int) -> Feed {
        return Feed(
            id: self.id,
            userID: self.userID,
            username: self.username,
            userImageURL: self.userImageURL,
            feedImageURL: self.feedImageURL,
            isReport: self.id == reportFeedID ? true : self.isReport
        )
    }
}
