//
//  AlertEmergencyType.swift
//  Baggle
//
//  Created by youtak on 2023/08/21.
//

import Foundation

enum AlertEmergencyType: Equatable {
    case invalidAuthorizationTime // 유효하지 않은 시간
    case accessDenied // 접근 권한 없음
    case notFound // 모임 참가자 x
    case networkError(String) // 네트워크 에러
    case userError // 유저 에러
}

extension AlertEmergencyType: AlertType {
    
    var buttonType: AlertButtonType { return .one }
    
    var title: String {
        switch self {
        case .invalidAuthorizationTime: return "인증 시간 에러"
        case .accessDenied: return "접근 권한이 없어요"
        case .notFound: return "모임 참가자가 없어요"
        case .networkError: return "네트워크 에러"
        case .userError: return "유저 정보 에러"
        }
    }
    
    var description: String {
        switch self {
        case .invalidAuthorizationTime: return "유효하지 않은 인증 시간이에요."
        case .accessDenied: return "모임에 접근할 수 있는 권한이 없어요. 재로그인 해주세요."
        case .notFound: return "서버에서 모임 정보를 찾을 수 없어요."
        case .networkError(let error): return "네트워크 에러 \(error)"
        case .userError: return "유저 정보를 불러오는데 에러가 발생했어요. 재로그인 해주세요."
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .invalidAuthorizationTime: return "돌아가기"
        case .accessDenied: return "재로그인"
        case .notFound: return "확인"
        case .networkError: return "확인"
        case .userError: return "재로그인"
        }
    }
}
