//
//  AlertMyPageType.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/03.
//

import Foundation

enum AlertMainTabType: Equatable {
    case logout
    case withdraw
    case error(APIError)
    case networkError
    case keychainError
}

extension AlertMainTabType: AlertType {
    var buttonType: AlertButtonType {
        switch self {
        case .networkError, .error, .keychainError: return .one
        case .logout, .withdraw: return .two
        }
    }
    
    var title: String {
        switch self {
        case .logout: return "로그아웃 하시겠어요?"
        case .withdraw: return "정말 탈퇴하시겠어요?"
        case .networkError: return "네트워크 에러"
        case .error, .keychainError: return "잠시 후 다시 시도해주세요."
        }
    }
    
    var description: String {
        switch self {
        case .logout: return "로그아웃을 해도 입력한\n약속 정보는 사라지지 않아요!"
        case .withdraw: return "입력하신 개인정보와\n약속정보는 모두 삭제돼요!"
        case .networkError: return "네트워크 에러가 발생했어요.\n잠시 후 다시 시도해주세요."
        case .error(let error): return error.errorDescription ?? "내부에서 문제가 발생했어요.\n잠시 후 다시 시도해주세요."
        case .keychainError: return "키체인 에러가 발생했어요."
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .logout: return "로그아웃"
        case .withdraw: return "탈퇴하기"
        case .networkError: return "확인"
        case .error: return "확인"
        case .keychainError: return "확인"
        }
    }
    
    var rightButtonType: RightAlertButtonType {
        switch self {
        case .logout,
                .networkError,
                .error,
                .keychainError:
            return .none
        case .withdraw:
            return .destructive
        }
    }
}
