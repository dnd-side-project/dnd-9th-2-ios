//
//  MeetingStatusEntity.swift
//  Baggle
//
//  Created by youtak on 2023/08/22.
//

import Foundation

enum MeetingStatusEntity: String, Codable {
    case scheduled = "SCHEDULED"
    case confirmation = "CONFIRMATION"
    case onGoing = "ONGOING"
    case termination = "TERMINATION"
    case past = "PAST"
}
