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

extension Font {
    
    struct Baggle {
        static let title = Font.baggleFont(size: 24, weight: .bold)
        static let subTitle = Font.baggleFont(size: 22, weight: .bold)
        static let button = Font.baggleFont(size: 16, weight: .semibold)
        static let body1 = Font.baggleFont(size: 18, weight: .bold)
        static let body2 = Font.baggleFont(size: 16, weight: .medium)
        static let body3 = Font.baggleFont(size: 15, weight: .medium)
        static let description = Font.baggleFont(size: 14, weight: .medium)
        static let caption1 = Font.baggleFont(size: 13, weight: .medium)
        static let caption2 = Font.baggleFont(size: 12, weight: .semibold)
    }
}
