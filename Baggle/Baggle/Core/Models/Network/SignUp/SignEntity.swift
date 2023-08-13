//
//  LoginEntity.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/10.
//

import Foundation

/// SignUp, SignIn에서 공통으로 사용되는 Entity입니다.
struct SignEntity: Codable {
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

extension SignEntity {
    func toDomain() -> User {
        return User(id: userID,
                    name: nickname,
                    profileImageURL: profileImageUrl,
                    platform: platform == "kakao" ? .kakao : .apple)
    }
}
