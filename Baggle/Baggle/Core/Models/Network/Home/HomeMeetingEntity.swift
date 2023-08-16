//
//  HomeMeetingEntity.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

struct HomeMeetingEntity: Codable {
    let remainingDate: Int
    let title: String
    let place: String
    let time: String
    let particiantCount: Int
    let status: String
    let users: [String?]
}
