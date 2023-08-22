//
//  MeetingDetailMemberEntity.swift
//  Baggle
//
//  Created by youtak on 2023/08/09.
//

import Foundation

struct MeetingDetailMemberEntity: Codable {
    let memberID: Int
    let nickname: String
    let profileImageURL: String?
    let meetingAuthority: Bool
    let buttonAuthority: Bool
    let feedID: Int?
    let feedImageURL: String

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case profileImageURL = "profileImageUrl"
        case feedID = "feedId"
        case feedImageURL = "feedImageUrl"
        case nickname, meetingAuthority, buttonAuthority
    }
}

extension MeetingDetailMemberEntity {

    // 모임 확정 전까지 버튼 권한자를 안 보여줌
    func memberDomain(afterMeetingConfirmed: Bool) -> Member {
        return Member(
            id: self.memberID,
            name: self.nickname,
            profileURL: self.profileImageURL,
            isMeetingAuthority: self.meetingAuthority,
            isButtonAuthority: afterMeetingConfirmed ? self.buttonAuthority : false,
            certified: self.feedID != nil,
            certImage: self.feedImageURL
        )
    }

    func feedDomain() -> Feed? {
        guard let feedID = feedID else { return nil }
        return Feed(
            id: feedID,
            userID: self.memberID,
            username: self.nickname,
            userImageURL: self.profileImageURL,
            feedImageURL: self.feedImageURL
        )
    }
}
