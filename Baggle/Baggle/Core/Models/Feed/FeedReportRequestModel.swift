//
//  FeedReportRequestModel.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/18.
//

import Foundation

struct FeedReportRequestModel: Equatable {
    let memberID: Int
    let feedID: Int
    let reportType: ReportType?
}

extension FeedReportRequestModel {
    func updateReportType(reportType: ReportType) -> FeedReportRequestModel {
        return FeedReportRequestModel(
            memberID: memberID,
            feedID: feedID,
            reportType: reportType
        )
    }
}
