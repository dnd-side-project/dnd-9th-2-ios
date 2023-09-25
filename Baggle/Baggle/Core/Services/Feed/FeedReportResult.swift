//
//  FeedReportResult.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/18.
//

import Foundation

enum FeedReportResult: Equatable {
    case success(Int) // 신고한 Feed ID
    case fail(APIError)
    case userError
}
