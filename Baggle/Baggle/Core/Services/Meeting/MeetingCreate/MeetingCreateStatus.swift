//
//  MeetingCreateStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/16.
//

import Foundation

enum MeetingCreateStatus: Equatable {
    case success(MeetingSuccessModel)
    case error
    case userError
    case requestModelError
}
