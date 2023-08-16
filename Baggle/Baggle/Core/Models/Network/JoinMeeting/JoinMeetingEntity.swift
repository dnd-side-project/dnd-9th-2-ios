//
//  JoinMeetingEntity.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/14.
//

import Foundation

struct JoinMeetingEntity: Codable {
    let participationID: Int
    
    enum CodingKeys: String, CodingKey {
        case participationID = "participationId"
    }
}
