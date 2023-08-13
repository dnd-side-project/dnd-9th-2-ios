//
//  JoinMeetingInfoEntity.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/13.
//

import Foundation

struct JoinMeetingInfoEntity: Codable {
    let meetingID: Int
    let title, place, date, time: String
    let memo: String

    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case title, place, date, time, memo
    }
}

extension JoinMeetingInfoEntity {
    func toDomain() -> JoinMeeting {
        let date = date.split(separator: "-").compactMap({ Int($0) })
        let time = String(time.prefix(5))
        return JoinMeeting(meetingId: meetingID,
                           title: title,
                           place: place,
                           date: "\(date[0])년 \(date[1])월 \(date[2])일",
                           time: time)
    }
}
