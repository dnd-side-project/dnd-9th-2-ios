//
//  BaggleAlertType.swift
//  Baggle
//
//  Created by youtak on 2023/08/17.
//

import SwiftUI

enum BaggleAlertType {
    case none
    case destructive
}

extension BaggleAlertType {
    var backgroundColor: Color {
        switch self {
        case .none: return .primaryNormal
        case .destructive: return .baggleRed
        }
    }
}
