//
//  Font+.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/07.
//

import SwiftUI

enum FontType {
    case title
    case subTitle
    case button
    case body1
    case body2
    case body3
    case description
    case caption1
    case caption2

    var size: CGFloat {
        switch self {
        case .title: return 24
        case .subTitle: return 22
        case .button: return 16
        case .body1: return 18
        case .body2: return 16
        case .body3: return 15
        case .description: return 14
        case .caption1: return 13
        case .caption2: return 12
        }
    }
}

extension Font {
    static func baggleFont(fontType: FontType, weight: Font.Weight) -> Font {
        
        let size = fontType.size
        
        switch weight {
        case .bold: return .custom("AppleSDGothicNeo-Bold", size: size)
        case .semibold: return .custom("AppleSDGothicNeo-SemiBold", size: size)
        case .medium: return .custom("AppleSDGothicNeo-Medium", size: size)
        case .regular: return .custom("AppleSDGothicNeo-Regular", size: size)
        default: return .custom("AppleSDGothicNeo-Regular", size: size)
        }
    }
}

extension Font {
    struct Baggle {
        static let title = Font.baggleFont(fontType: .title, weight: .bold)
        static let subTitle = Font.baggleFont(fontType: .subTitle, weight: .bold)
        static let button = Font.baggleFont(fontType: .button, weight: .semibold)
        static let body1 = Font.baggleFont(fontType: .body1, weight: .bold)
        static let body2 = Font.baggleFont(fontType: .body2, weight: .medium)
        static let body3 = Font.baggleFont(fontType: .body3, weight: .medium)
        static let description = Font.baggleFont(fontType: .description, weight: .medium)
        static let caption1 = Font.baggleFont(fontType: .caption1, weight: .medium)
        static let caption2 = Font.baggleFont(fontType: .caption2, weight: .semibold)
        
        static func font(_ fontType: FontType) -> Font {
            switch fontType {
            case .title: return self.title
            case .subTitle: return self.subTitle
            case .button: return self.button
            case .body1: return self.body1
            case .body2: return self.body2
            case .body3: return self.body3
            case .description: return self.description
            case .caption1: return self.caption1
            case .caption2: return self.caption2
            }
        }
    }
}
