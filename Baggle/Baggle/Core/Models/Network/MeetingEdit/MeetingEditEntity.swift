//
//  MeetingEditEntity.swift
//  Baggle
//
//  Created by youtak on 2023/09/12.
//

import Foundation

struct MeetingEditEntity: Decodable {
    let meetingID: Int
    let title: String
    let place: String
    let meetingTime: Date
    let memo: String
    
    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case meetingTime = "dateTime"
        case title, place, memo
    }
}

extension MeetingEditEntity {
    func toDomain() -> MeetingEditSuccessModel {
        MeetingEditSuccessModel(
            meetingID: meetingID,
            title: title,
            place: place,
            meetingTime: meetingTime,
            memo: memo.isEmpty ? nil : memo
        )
    }
}
