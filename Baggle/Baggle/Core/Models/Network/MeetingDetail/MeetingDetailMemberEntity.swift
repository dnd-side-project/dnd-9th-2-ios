//
//  MeetingDetailMemberEntity.swift
//  Baggle
//
//  Created by youtak on 2023/08/09.
//

import Foundation

struct MeetingDetailMemberEntity: Codable {
    let memberId: Int
    let nickname: String
    let profileImageUrl: String
    let meetingAuthority: Bool
    let buttonAuthority: Bool
    let feedId: String?
    let feedImageUrl: String
}
