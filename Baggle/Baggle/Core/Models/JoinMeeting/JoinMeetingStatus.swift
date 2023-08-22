//
//  JoinMeetingStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/14.
//

import Foundation

enum JoinMeetingStatus: Equatable {
    case enable(JoinMeeting)
    case expired(APIError)
    case joined
    case fail(APIError)
}

enum JoinMeetingResultStatus: Equatable {
    case success
    case fail(APIError)
}
