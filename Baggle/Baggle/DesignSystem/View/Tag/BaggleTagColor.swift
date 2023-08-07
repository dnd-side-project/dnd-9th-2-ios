//
//  BaggleColor.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/24.
//

import SwiftUI

enum BaggleTagColor {
    case primary
    case red

    var bgColor: Color {
        switch self {
        case .primary:
            return Color.primaryNormal
        case .red:
            return Color.baggleRed
        }
    }
}
