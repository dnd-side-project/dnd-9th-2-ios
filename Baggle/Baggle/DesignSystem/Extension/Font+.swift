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
    
    var weight: Font.Weight {
        switch self {
        case .title: return .bold
        case .subTitle: return .bold
        case .button: return .semibold
        case .body1: return .bold
        case .body2: return .medium
        case .body3: return .medium
        case .description: return .medium
        case .caption1: return .medium
        case .caption2: return .semibold
        }
    }
}

extension Font {
    static func baggleFont(fontType: FontType) -> Font {
        
        let size = fontType.size
        
        switch fontType.weight {
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
        static let title = Font.baggleFont(fontType: .title)
        static let subTitle = Font.baggleFont(fontType: .subTitle)
        static let button = Font.baggleFont(fontType: .button)
        static let body1 = Font.baggleFont(fontType: .body1)
        static let body2 = Font.baggleFont(fontType: .body2)
        static let body3 = Font.baggleFont(fontType: .body3)
        static let description = Font.baggleFont(fontType: .description)
        static let caption1 = Font.baggleFont(fontType: .caption1)
        static let caption2 = Font.baggleFont(fontType: .caption2)
    }
}
