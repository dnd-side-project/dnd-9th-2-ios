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
        case .inactive: return Color.grayBF
        case .active: return Color.primaryNormal
        case .valid: return Color.gray43
        case .invalid: return Color.baggleRed
        }
    }

    var borderColor: Color {
        switch self {
        case .inactive: return Color.grayD9
        case .active: return Color.primaryNormal
        case .valid: return Color.gray59
        case .invalid: return Color.baggleRed
        }
    }
}
