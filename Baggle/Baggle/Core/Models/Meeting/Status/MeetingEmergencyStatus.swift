//
//  MeetingEmergencyStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/22.
//

import Foundation

enum MeetingEmergencyStatus: Equatable {
    case scheduled // 확정 전
    case confirmation // 모임 확정 후
    case onGoing // 긴급 소집 중
    case termination // 긴급 소집 종료
    case past // 모임 종료 (모임 시간 + 4시간)
}
