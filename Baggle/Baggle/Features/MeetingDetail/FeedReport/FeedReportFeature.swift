//
//  FeedReportFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/18.
//

import ComposableArchitecture

struct FeedReportFeature: ReducerProtocol {
    
    struct State: Equatable {
        
        // MARK: - Scope State
        
        var selectedType: ReportType?
        var reportButtonDisabled: Bool = true
    }
    
    enum Action: Equatable {
        case cancelButtonTapped
        case reportButtonTapped
        case reportTypeSelected(ReportType)
        case disappear
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerProtocolOf<Self> {
        
        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .reportButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .reportTypeSelected(let reportType):
                state.selectedType = reportType
                state.reportButtonDisabled = false
                return .none
                
            case .disappear:
                return .none
            }
        }
    }
}
