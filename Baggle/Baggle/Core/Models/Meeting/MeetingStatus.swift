//
//  MeetingStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/08.
//

import SwiftUI

enum MeetingStatus {
    case ready // 약속 전날까지
    case progress // 약속 당일
    case confirmed // 약속 당일 && 약속 1시간 전
    case completed // 지난 약속

    var segmentTitle: String {
        switch self {
        case .ready, .progress, .confirmed: return "예정된 약속"
        case .completed: return "지난 약속"
        }
    }

    var fgColor: Color {
        switch self {
        case .ready, .completed, .confirmed: return .grayBF
        case .progress: return .baggleRed
        }
    }
}

extension MeetingStatus {
    func create(date: Date) -> MeetingStatus {

        // 약속 전날
        if date.isUpcomingDays {
            return .ready
        }

        // 약속 날 지났을 때
        if date.isPreviousDays {
            return .completed
        }

        // 약속 당일 1 시간 전 ~ 약속 당일 (약속 당일보다 무조건 먼저와야 함)
        if date.inTheNextHour {
            return .confirmed
        }
        // 약속 당일
        
        if date.isInToday {
            return .progress
        }
        
        fatalError("약속 로직 에러")
    }
}
