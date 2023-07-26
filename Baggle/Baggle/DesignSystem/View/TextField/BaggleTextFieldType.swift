//
//  BaggleTextFieldType.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

/// 상단 타이틀 유무에 따른 TextFieldTitle
enum TextFieldTitle {
    case basic // 상단 타이틀 X (default)
    case title(String) // 상단 타이틀 O
}

/// 사용 가능 여부에 따른 TextFieldState
enum TextFieldState: Equatable {
    case inactive // 입력 전
    case active // 입력 중
    case valid // 입력 후 (사용 가능)
    case invalid(String) // 입력 후 (사용 불가능)

    var fgColor: Color {
        switch self {
        case .inactive:
            return Color.gray
        case .active:
            return Color.blue
        case .valid:
            return Color.black
        case .invalid:
            return Color.red
        }
    }

    var borderColor: Color {
        switch self {
        case .inactive:
            return Color.gray.opacity(0.3)
        case .active:
            return Color.blue
        case .valid:
            return Color.black.opacity(0.8)
        case .invalid:
            return Color.red
        }
    }
}

/// 우측 버튼에 따른 TextFieldButton
enum TextFieldButton {
    case delete // 텍스트 삭제 버튼 (default)
    case iconImage(String) // 그 외 아이콘 string 값을 직접 받아 커스텀할 버튼
}
