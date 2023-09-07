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
    case networkError(String)
    case userError
}

extension AlertMainTabType: AlertType {

    var buttonType: AlertButtonType {
        switch self {
        case .networkError, .userError: return .one
        case .logout: return .two(.none)
        case .withdraw: return .two(.destructive)
        }
    }
    
    var title: String {
        switch self {
        case .logout: return "로그아웃 하시겠어요?"
        case .withdraw: return "정말 탈퇴하시겠어요?"
        case .networkError: return "네트워크 에러"
        case .userError: return "유저 정보 저장 에러"
        }
    }
    
    var description: String {
        switch self {
        case .logout: return "로그아웃을 해도 입력한\n약속 정보는 사라지지 않아요!"
        case .withdraw: return "입력하신 개인정보와\n약속정보는 모두 삭제돼요!"
        case .networkError(let description): return "네트워크 에러가 발생했어요.\n잠시 후 다시 시도해주세요. \(description)"
        case .userError: return "로컬에 유저 정보 저장 중 에러가 발생했어요.\n로그인 후 다시 시도해주세요."
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .logout: return "로그아웃"
        case .withdraw: return "탈퇴하기"
        case .networkError: return "확인"
        case .userError: return "재로그인"
        }
    }
}
