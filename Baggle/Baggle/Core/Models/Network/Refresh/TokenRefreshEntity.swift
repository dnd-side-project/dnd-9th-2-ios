//
//  TokenRefreshEntity.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/05.
//

import Foundation

struct TokenRefreshEntity: Codable {
    let accessToken: String
    let refreshToken: String
}
