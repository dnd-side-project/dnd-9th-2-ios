//
//  MeetingCreateEntity.swift
//  Baggle
//
//  Created by youtak on 2023/08/16.
//

import Foundation

struct MeetingCreateEntity: Decodable {
    let meetingID: Int
    
    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
    }
}
