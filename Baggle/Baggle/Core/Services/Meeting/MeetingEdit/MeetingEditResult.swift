//
//  MeetingEditResult.swift
//  Baggle
//
//  Created by youtak on 2023/09/12.
//

import Foundation

enum MeetingEditResult: Equatable {
    case success(MeetingEditSuccessModel)
    case userError
    case notFound
    case networkError(String)
}
