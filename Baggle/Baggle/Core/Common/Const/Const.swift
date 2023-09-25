//
//  Const.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/14.
//

import Foundation

// swiftlint:disable all
struct Const {
    struct URL {
        static let privacyPolicy = "https://astonishing-grip-068.notion.site/80761a06565b4b94af888d6d902e42a3?pvs=4"
        static let termsOfService = "https://astonishing-grip-068.notion.site/22159fe196184050b444824606bb6e46?pvs=4"
        static let invitationThumbnail = "https://bagglebucket.s3.ap-northeast-2.amazonaws.com/link_participation.png"
        static let kakaoAppStore = "itms-apps://itunes.apple.com/app/362057947"
    }
    
    struct Account {
        static let mail = "kingzzangssang@gmail.com"
    }
    
    struct Image {
        static let jpegCompression: CGFloat = 0.9
    }
    
    struct ErrorID {
        static let user: Int = -999
        static let meeting: Int = -999
    }
    
    struct Animation {
        static let loginButton: CGFloat = 0.3
    }
}
// swiftlint:enable all
