//
//  JoinMeetingStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/14.
//

import Foundation

enum JoinMeetingResult: Equatable {
    case enable(JoinMeeting)
    case expired(APIError)
    case joined
    case fail(APIError)
}

enum JoinMeetingPostResult: Equatable {
    case success
    case fail(APIError)
}
