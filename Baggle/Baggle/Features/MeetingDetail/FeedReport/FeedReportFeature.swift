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
    }
    
    enum Action: Equatable {
        case reportTypeSelected(ReportType)
        case disappear
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerProtocolOf<Self> {
        
        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in
            switch action {
            case .reportTypeSelected:
                return .run { _ in await self.dismiss() }
                
            case .disappear:
                return .none
            }
        }
    }
}
