//
//  BaggleColor.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/24.
//

import SwiftUI

enum BaggleColor {
    case blue
    case pink

    var bgColor: Color {
        switch self {
        case .blue:
            return Color.blue
        case .pink:
            return Color.pink
        }
    }
}
