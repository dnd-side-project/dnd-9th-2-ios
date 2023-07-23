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
        case .medium: return 0.7
        case .large: return 0.9
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

struct ButtonType {
    var size: ButtonSize
    var shape: ButtonShape
}

/// 버튼 상태
/// - 추후 디자인 반영 수정
enum ButtonState {
    case disable
    case enable

    var bgColor: Color {
        switch self {
        case .disable: return .gray
        case .enable: return .blue
        }
    }

    var fgColor: Color {
        switch self {
        case .disable: return .white
        case .enable: return .white
        }
    }
}
