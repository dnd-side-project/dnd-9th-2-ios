//
//  HomeEntity.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

struct HomeEntity: Codable {
    let scheduledCount: Int
    let pastCount: Int
    let meetings: [HomeMeetingEntity]

    enum CodingKeys: String, CodingKey {
        case scheduledCount, pastCount, meetings
    }
}

// TODO: - toDomain


