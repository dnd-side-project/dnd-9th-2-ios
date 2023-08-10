//
//  User.swift
//  Baggle
//
//  Created by youtak on 2023/08/10.
//

import Foundation

public struct User: Codable {
    let id: Int
    let name: String
    let profileImageURL: String
    let platform: LoginPlatform
}
