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
    let profileImageURL: String
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
