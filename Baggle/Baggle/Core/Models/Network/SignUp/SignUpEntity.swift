//
//  SignUpEntity.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/10.
//

import Foundation

struct SignUpEntity: Codable {
    let accessToken: String
    let refreshToken: String
    let platform: String
    let userID: Int
    let profileImageUrl: String?
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case profileImageUrl = "profileImageURL"
        case accessToken, refreshToken, platform, nickname
    }
}

extension SignUpEntity {
    // User 모델로
}
