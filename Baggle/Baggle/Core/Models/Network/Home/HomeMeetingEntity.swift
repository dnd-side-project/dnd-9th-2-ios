//
//  HomeMeetingEntity.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

struct HomeMeetingEntity: Codable {
    let meetingID: Int
    let remainingDate: Int
    let title: String
    let place: String
    let time: Date
    let participantCount: Int
    let status: MeetingStatusEntity
    let participants: [String]
    
    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case remainingDate, title, place, time, participantCount, status, participants
    }
}

extension HomeMeetingEntity {
    func toDomain() -> Meeting {
        return Meeting(
            id: meetingID,
            name: title,
            place: place,
            date: time.koreanDate(),
            time: time.hourMinute(),
            dDay: remainingDate,
            profileImages: participants,
            homeStatus: status.meetingHomeStatus(),
            stampStatus: status.meetingStampStatus(remainingDay: remainingDate)
        )
    }
}
