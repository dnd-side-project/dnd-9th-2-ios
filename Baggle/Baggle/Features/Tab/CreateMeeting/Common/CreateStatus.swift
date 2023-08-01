//
//  CreateStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import Foundation

enum CreateStatus: CaseIterable {
    case title
    case place
    case date
    case memo

    var index: Int {
        switch self {
        case .title: return 0
        case .place: return 1
        case .date: return 2
        case .memo: return 3
        }
    }

    static var array: [String] {
        return Array(1...CreateStatus.allCases.count).map { String($0) }
    }
}
