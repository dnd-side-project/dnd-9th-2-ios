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
    
    var segmentTitle: String {
        switch self {
        case .scheduled: return "예정된 약속"
        case .past: return "지난 약속"
        }
    }
    
    var period: String {
        switch self {
        case .scheduled: return "scheduled"
        case .past: return "past"
        }
    }
}
