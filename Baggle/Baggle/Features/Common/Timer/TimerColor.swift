//
//  TimerStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/08.
//

import SwiftUI

enum TimerColor {
    case black
    case white
}

extension TimerColor {

    var backgroundColor: Color {
        switch self {
        case .black: return .black
        case .white: return .white
        }
    }

    var foregroundColor: Color {
        switch self {
        case .black: return .white
        case .white: return .black
        }
    }
}
