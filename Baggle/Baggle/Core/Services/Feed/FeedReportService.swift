//
//  FeedReportService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/18.
//

import Foundation

import ComposableArchitecture

struct FeedReportService {
    var postFeedReport: (_ requestModel: FeedReportRequestModel) async -> FeedReportResult
}

extension FeedReportService: DependencyKey {
    
    static let networkService = NetworkService<ReportAPI>()
    
    static var liveValue = Self { requestModel in
        do {
            return try await Task.retrying(operation: {
                guard let token = UserManager.shared.accessToken else {
                    return .userError
                }
                
                try await networkService.requestWithNoResult(
                    .feedReport(
                        requestModel: requestModel,
                        token: token
                    )
                )
                
                let reportFeedID = requestModel.feedID
                
                return .success(reportFeedID)
            }).value
        } catch {
            guard let error = error as? APIError else { return .fail(.network) }
            return .fail(error)
        }
    }
}

extension DependencyValues {
    var feedReportService: FeedReportService {
        get { self[FeedReportService.self] }
        set { self[FeedReportService.self] = newValue }
    }
}
