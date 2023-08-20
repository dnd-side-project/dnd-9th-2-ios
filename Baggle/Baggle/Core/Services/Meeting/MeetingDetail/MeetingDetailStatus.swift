//
//  MeetingDetailStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/14.
//

import Foundation

enum MeetingDetailStatus: Equatable {
    case success(MeetingDetail)
    case userError
    case notFound
    case networkError(String)
}
