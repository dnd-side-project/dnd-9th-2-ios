//
//  NotiList.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import Foundation

extension Notification.Name {
    static let moveMeetingDetail = Notification.Name(rawValue: "moveMeetingDetail")
    static let refreshMeetingList = Notification.Name("refreshMeetingList")
    static let joinMeeting = Notification.Name("joinMeeting")
    static let skipSplashMeetingDetail = Notification.Name(rawValue: "skipSplashMeetingDetail")
    static let skipSplashJoinMeeting = Notification.Name("skipSplashJoinMeeting")
}
