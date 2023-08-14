//
//  JoinMeetingStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/14.
//

import Foundation

// TODO: - 모임 참여 불가(2시간 전후 일정 존재, 모임 인원 초과) 추가
enum JoinMeetingStatus: Equatable {
    case enable(JoinMeeting)
    case expired
    case joined
    case fail(APIError)
}

enum JoinMeetingResultStatus: Equatable {
    case success
    case fail(APIError)
}
