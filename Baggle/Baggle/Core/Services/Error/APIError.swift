//
//  NetworkError.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

enum APIError: Error, Equatable {
    case badRequest // 400
    case unauthorized // 401, 토큰 에러
    case notFound // 404, 리소스 또는 유저 정보 없음
    case duplicatedUser // 409, 이미 존재하는 회원
    case duplicatedNickname // 409, 닉네임 중복
    case duplicatedJoinMeeting // 409, 이미 참여한 약속
    case expiredMeeting // 만료된 약속
    case server // 500
    case network // 네트워크 에러
    case decoding // 디코딩 에러
    case jsonEncodingError
}
