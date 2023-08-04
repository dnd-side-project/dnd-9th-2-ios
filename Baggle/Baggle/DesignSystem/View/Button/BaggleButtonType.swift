//
//  BaggleButtonType.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

/// 버튼 크기
enum ButtonSize {
    case small
    case medium
    case large

    var ratio: CGFloat {
        switch self {
        case .small: return 0.5
        case .medium: return 0.79
        case .large: return 0.89
        }
    }
}

/// 버튼 형태
enum ButtonShape {
    case square
    case round

    var radius: CGFloat {
        switch self {
        case .square: return 6
        case .round: return 30
        }
    }
}
