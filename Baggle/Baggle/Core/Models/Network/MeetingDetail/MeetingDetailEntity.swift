//
//  MeetingDetailEntity.swift
//  Baggle
//
//  Created by youtak on 2023/08/09.
//

import Foundation

struct MeetingDetailEntity: Codable {
    let meetingId: Int
    let title: String
    let place: String
    let meetingTime: Date
    let memo: String?
    let certificationTime: Date
    let members: [MeetingDetailMemberEntity]
}
