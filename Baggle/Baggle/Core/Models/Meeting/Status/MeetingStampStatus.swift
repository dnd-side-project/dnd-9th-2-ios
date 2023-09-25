//
//  MeetingStampStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/22.
//

import SwiftUI

enum MeetingStampStatus: Equatable {
    case scheduled
    case dDay
    case confirmation
    case termination
}

extension MeetingStampStatus {
    
    var foregroundColor: Color {
        switch self {
        case .scheduled, .termination: return .gray5
        case .dDay, .confirmation: return .baggleRed
        }
    }
}
