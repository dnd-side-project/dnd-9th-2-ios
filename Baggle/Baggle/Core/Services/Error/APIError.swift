//
//  NetworkError.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

enum APIError: Error, Equatable {
    case badRequest // 400
    case unauthorized // 401, 소셜로그인 에러
    case duplicatedUser // 409, 이미 존재하는 회원
    case duplicatedNickname // 409, 닉네임 중복
    case server // 500
    case network // 네트워크 에러
    case decoding // 디코딩 에러
    case keychain(status: OSStatus)
}