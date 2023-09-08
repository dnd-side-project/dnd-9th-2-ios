//
//  NetworkError.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

enum APIError: Error, Equatable {
    
    // MARK: - 400
    
    case badRequest // 400
    case duplicatedMeeting // 400, 모임 2시간 전후 일정 존재
    case invalidMeetingDeleteTime // 400 모임 확정 이후 나갈 수 없음 (모임 확정 됨)
    
    // MARK: - 401
    
    case unauthorized // 401, 토큰 에러
    
    // MARK: - 403
    
    case limitMeetingCount // 403, 모임 생성 최대 개수 초과
    case exceedMemberCount // 403, 모임 참여 가능 인원 초과
    case forbidden // 403, 리소스 접근 제한
    
    // MARK: - 404
    
    case notFound // 404, 리소스 또는 유저 정보 없음
    
    // MARK: - 409
    
    case duplicatedUser // 409, 이미 존재하는 회원
    case duplicatedNickname // 409, 닉네임 중복
    case duplicatedJoinMeeting // 409, 이미 참여한 약속
    case expiredMeeting // 만료된 약속

    // MARK: - 500
    
    case server // 500

    // MARK: - 그외
    
    case network // 네트워크 에러
    case decoding // 디코딩 에러
    case jsonEncodingError // Encoding 에러
    case unwrapping // 데이터가 있어야 할 곳에 nil이 옴
    case providerRequest // Moya Provider Request시 에러
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            // MARK: - 400
            
        case .badRequest: return "400 에러"
        case .duplicatedMeeting: return "모임 2시간 전후 일정 존재"
        case .invalidMeetingDeleteTime: return "모임 확정 이후 나갈 수 없음"
        
            
            // MARK: - 401
            
        case .unauthorized: return "401 에러"
            
            // MARK: - 403
            
        case .limitMeetingCount: return "모임 2시간 전후 생성 불가"
        case .exceedMemberCount: return "모임 참여 가능 인원 초과"
        case .forbidden: return "403 에러"
            
            // MARK: - 404
            
        case .notFound: return "404 에러"
            
            // MARK: - 409
            
        case .duplicatedUser: return "409 에러"
        case .duplicatedNickname: return "409 에러"
        case .duplicatedJoinMeeting: return "409 에러"
        case .expiredMeeting: return "만료된 약속"
            
            // MARK: - 500
            
        case .server: return "500 서버 에러"
            
            // MARK: - 그외
            
        case .network: return "네트워크 에러"
        case .decoding: return "디코딩 에러"
        case .jsonEncodingError: return "인코딩 에러"
        case .unwrapping: return "데이터 빈 값"
        case .providerRequest: return "네트워크 요청 생성 에러"
        }
    }
}
