//
//  SignUpRequestModel.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/10.
//

import Foundation

struct SignUpRequestModel {
    let nickname: String
    let profilImageUrl: Data?
    let platform: LoginPlatform
    let fcmToken: String
}
