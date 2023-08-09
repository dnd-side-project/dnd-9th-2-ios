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
    let certificationTime: Date?
    let members: [MeetingDetailMemberEntity]

    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case title, place, meetingTime, memo, certificationTime, members
    }
}

extension MeetingDetailEntity {
    func toDomain() -> MeetingDetail {
        MeetingDetail(
            id: self.meetingID,
            name: self.title,
            place: self.place,
            date: self.meetingTime.koreanDate(),
            time: self.meetingTime.hourMinute(),
            memo: self.memo,
            members: self.members.map { $0.memberDomain() },
            status: .completed,
            emergencyButtonActive: self.certificationTime != nil,
            emergencyButtonActiveTime: self.certificationTime,
            feeds: self.members.compactMap { $0.feedDomain() }
        )
    }
}
