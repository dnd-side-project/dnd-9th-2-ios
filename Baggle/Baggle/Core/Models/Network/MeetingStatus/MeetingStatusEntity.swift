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

extension MeetingStatusEntity {
    
    func meetingHomeStatus() -> MeetingHomeStatus {
        switch self {
        case .scheduled, .confirmation, .onGoing, .termination: return .scheduled
        case .past: return .past
        }
    }
    
    func meetingStampStatus() -> MeetingStampStatus {
        switch self {
        case .scheduled: return .confirmation
        case .confirmation, .onGoing, .termination: return .confirmation
        case .past: return .termination
        }
    }
    
    func meetingEmergencyStatus() -> MeetingEmergencyStatus {
        switch self {
        case .scheduled: return .scheduled
        case .confirmation: return .confirmation
        case .onGoing: return .onGoing
        case .termination: return .termination
        case .past: return .past
        }
    }
}
