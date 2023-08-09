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
            status: meetingStatus(date: self.meetingTime),
            emergencyButtonActive: self.certificationTime != nil,
            emergencyButtonActiveTime: self.certificationTime,
            feeds: self.members.compactMap { $0.feedDomain() }
        )
    }
    
    private func meetingStatus(date: Date) -> MeetingStatus {
        
        // 약속 전날
        if date.isUpcomingDays {
            return .ready
        }

        // 약속 날 지났을 때
        if date.isPreviousDays {
            return .completed
        }

        // 약속 당일 1 시간 전 ~ 약속 당일 (약속 당일보다 무조건 먼저와야 함)
        if date.inTheNextHour {
            return .confirmed
        }

        // 약속 당일
        return .progress
    }
}
