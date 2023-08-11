//
//  NetworkError.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

enum APIError: Error {
    case badRequest // 400
    case unauthorized // 401, 소셜로그인 에러
    case duplicatedUserErr // 409, 이미 존재하는 회원
    case duplicatedNicknameErr // 409, 닉네임 중복
    case serverErr // 500
    case networkErr // 네트워크 에러
    case decodingErr // 디코딩 에러
}
