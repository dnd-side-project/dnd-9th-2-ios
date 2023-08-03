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

    var color: Color {
        switch self {
        case .inactive: return .gray.opacity(0.2)
        case .active: return .blue
        case .valid: return .black
        case .invalid: return .red
        }
    }
}
