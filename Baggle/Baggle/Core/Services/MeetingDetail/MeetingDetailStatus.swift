//
//  MeetingDetailStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/14.
//

import Foundation

enum MeetingDetailStatus {
    case success(MeetingDetail)
    case fail(APIError)
    case userError
}
