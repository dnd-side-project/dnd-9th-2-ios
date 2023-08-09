//
//  MeetingDetailEntity.swift
//  Baggle
//
//  Created by youtak on 2023/08/09.
//

import Foundation

struct MeetingDetailEntity: Codable {
    let meetingID: Int
    let title: String
    let place: String
    let meetingTime: Date
    let memo: String?
    let certificationTime: Date
    let members: [MeetingDetailMemberEntity]

    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case title, place, meetingTime, memo, certificationTime, members
    }
}
