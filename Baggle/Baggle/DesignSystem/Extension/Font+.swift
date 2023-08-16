//
//  Font+.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/07.
//

import SwiftUI

enum FontType {
    case title
    case subTitle1
    case subTitle2
    case button1
    case button2
    case body1
    case body2
    case body3
    case description1
    case description2
    case caption1
    case caption2
    case caption3
    case caption4

    var size: CGFloat {
        switch self {
        case .title: return 24
        case .subTitle1: return 22
        case .subTitle2: return 20
        case .button1: return 16
        case .button2: return 15
        case .body1: return 18
        case .body2: return 16
        case .body3: return 15
        case .description1: return 14
        case .description2: return 14
        case .caption1: return 13
        case .caption2: return 13
        case .caption3: return 12
        case .caption4: return 12
        }
    }
    
    var weight: Font.Weight {
        switch self {
        case .title: return .bold
        case .subTitle1: return .bold
        case .subTitle2: return .bold
        case .button1: return .semibold
        case .button2: return .bold
        case .body1: return .bold
        case .body2: return .medium
        case .body3: return .medium
        case .description1: return .semibold
        case .description2: return .medium
        case .caption1: return .bold
        case .caption2: return .medium
        case .caption3: return .semibold
        case .caption4: return .medium
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
        static let subTitle1 = Font.baggleFont(fontType: .subTitle1)
        static let subTitle2 = Font.baggleFont(fontType: .subTitle2)
        static let button1 = Font.baggleFont(fontType: .button1)
        static let button2 = Font.baggleFont(fontType: .button2)
        static let body1 = Font.baggleFont(fontType: .body1)
        static let body2 = Font.baggleFont(fontType: .body2)
        static let body3 = Font.baggleFont(fontType: .body3)
        static let description1 = Font.baggleFont(fontType: .description1)
        static let description2 = Font.baggleFont(fontType: .description2)
        static let caption1 = Font.baggleFont(fontType: .caption1)
        static let caption2 = Font.baggleFont(fontType: .caption2)
        static let caption3 = Font.baggleFont(fontType: .caption3)
        static let caption4 = Font.baggleFont(fontType: .caption4)
    }
}
