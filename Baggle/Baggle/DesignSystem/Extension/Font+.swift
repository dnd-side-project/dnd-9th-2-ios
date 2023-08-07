//
//  Font+.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/07.
//

import SwiftUI

extension Font {
    static func baggleFont(size: CGFloat, weight: Font.Weight) -> Font {
        switch weight {
        case .bold:
            return .custom("AppleSDGothicNeo-Bold", size: size)
        case .semibold:
            return .custom("AppleSDGothicNeo-SemiBold", size: size)
        case .medium:
            return .custom("AppleSDGothicNeo-Medium", size: size)
        case .regular:
            return .custom("AppleSDGothicNeo-Regular", size: size)
        default:
            return .custom("AppleSDGothicNeo-Regular", size: size)
        }
    }
}
