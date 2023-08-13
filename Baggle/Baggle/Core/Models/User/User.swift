//
//  User.swift
//  Baggle
//
//  Created by youtak on 2023/08/10.
//

import Foundation

public struct User: Codable, Equatable {
    let id: Int
    let name: String
    let profileImageURL: String?
    let platform: LoginPlatform
}

extension User {
    public static func error() -> User {
        User(
            id: -1,
            name: "에러",
            profileImageURL: "",
            platform: .apple
        )
    }
}

#if DEBUG
extension User {
    static func mockUp() -> User {
        User(
            id: 0,
            name: "바글이 테스터",
            profileImageURL: "https://avatars.githubusercontent.com/u/71776532?v=4",
            platform: .kakao
        )
    }
}

#endif
