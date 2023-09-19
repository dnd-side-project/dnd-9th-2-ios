//
//  ReportType.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/18.
//

import Foundation

enum ReportType: CaseIterable, Equatable {
    case sexually
    case violent
    case unpleasant
    
    var rawValue: String {
        switch self {
        case .sexually: return "sexually"
        case .violent: return "violent"
        case .unpleasant: return "unpleasant"
        }
    }
    
    var description: String {
        switch self {
        case .sexually:
            return "성적으로 부적절함"
        case .violent:
            return "폭력적이거나 금지된 콘텐츠임"
        case .unpleasant:
            return "불쾌한 게시글임"
        }
    }
}
