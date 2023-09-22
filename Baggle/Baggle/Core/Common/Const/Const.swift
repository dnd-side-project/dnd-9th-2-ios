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
        static let privacyPolicy = "https://www.dnd.ac/"
        static let termsOfService = "https://www.naver.com/"
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
