//
//  MeetingHomeStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/22.
//

import Foundation

enum MeetingHomeStatus: Equatable {
    case scheduled
    case past
}

extension MeetingHomeStatus {
    var period: String {
        switch self {
        case .scheduled: return "scheduled"
        case .past: return "past"
        }
    }
}
