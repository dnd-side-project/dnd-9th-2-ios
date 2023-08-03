//
//  BubbleType.swift
//  Baggle
//
//  Created by youtak on 2023/08/03.
//

import SwiftUI

enum BubbleType {
    case primary
    case secondary
}

extension BubbleType {

    var backgroundColor: Color {
        switch self {
        case .primary: return Color.blue
        case .secondary: return Color.black
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary: return Color.white
        case .secondary: return Color.white
        }
    }
}
