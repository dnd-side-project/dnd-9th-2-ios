//
//  UserToken.swift
//  Baggle
//
//  Created by youtak on 2023/08/18.
//

struct UserToken: Codable {
    var accessToken: String
    var refreshToken: String
    
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
