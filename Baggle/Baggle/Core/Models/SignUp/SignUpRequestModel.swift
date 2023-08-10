//
//  SignUpRequestModel.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/10.
//

import Foundation

struct SignUpRequestModel: Equatable {
    let nickname: String
    let profilImageUrl: Data?
    let platform: LoginPlatform
    let fcmToken: String
    
    static func == (lhs: SignUpRequestModel, rhs: SignUpRequestModel) -> Bool {
        return lhs.fcmToken == rhs.fcmToken
    }
}
