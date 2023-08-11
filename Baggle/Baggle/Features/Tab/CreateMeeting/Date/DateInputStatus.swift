//
//  DateButtonStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/02.
//

import SwiftUI

enum DateInputStatus {
    case inactive // 사용 전
    case active // 사용 중
    case valid // 사용 후 유효성 검사 전
    case invalid // 사용 불가
}

extension DateInputStatus {

    var foregroundColor: Color {
        switch self {
        case .inactive: return Color.gray5
        case .active: return Color.primaryNormal
        case .valid: return Color.gray8
        case .invalid: return Color.baggleRed
        }
    }

    var borderColor: Color {
        switch self {
        case .inactive: return Color.gray4
        case .active: return Color.primaryNormal
        case .valid: return Color.gray7
        case .invalid: return Color.baggleRed
        }
    }
}
