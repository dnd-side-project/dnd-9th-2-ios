//
//  EmergencyEntity.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

struct EmergencyEntity: Codable {
    let meetingID: Int
    let certificationTime: Date?

    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case certificationTime
    }
}
