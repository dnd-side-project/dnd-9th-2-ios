//
//  BubbleType.swift
//  Baggle
//
//  Created by youtak on 2023/08/03.
//

import SwiftUI

// MARK: - Bubble Size

enum BubbleSize {
    case medium
    case small
}

extension BubbleSize {

    var paddingHorizontal: CGFloat {
        switch self {
        case .medium: return 20
        case .small: return 12
        }
    }

    var paddingVertical: CGFloat {
        switch self {
        case .medium: return 14
        case .small: return 8
        }
    }
}

// MARK: - Bubble Color

enum BubbleColor {
    case primary
    case secondary
}

extension BubbleColor {

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
