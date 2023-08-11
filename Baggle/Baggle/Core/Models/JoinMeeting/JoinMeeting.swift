//
//  JoinMeeting.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/11.
//

import Foundation

enum JoinMeetingState: Equatable {
    case enable(JoinMeeting)
    case expired
    case joined
    case loading
}

struct JoinMeeting: Equatable {
    let meetingId: Int
    let title: String
    let place: String
    let date: String
    let time: String
    
    static func == (lhs: JoinMeeting, rhs: JoinMeeting) -> Bool {
        return lhs.meetingId == rhs.meetingId
    }
}
