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
}

extension AlertMainTabType: AlertType {
    var buttonType: AlertButtonType {
        switch self {
        case .logout, .withdraw: return .two
        }
    }
    
    var title: String {
        switch self {
        case .logout: return "로그아웃 하시겠어요?"
        case .withdraw: return "정말 탈퇴하시겠어요?"
        }
    }
    
    var description: String {
        switch self {
        case .logout: return "로그아웃을 해도 입력한\n약속 정보는 사라지지 않아요!"
        case .withdraw: return "입력하신 개인정보와\n약속정보는 모두 삭제돼요!"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .logout: return "로그아웃"
        case .withdraw: return "탈퇴하기"
        }
    }
    
    var rightButtonType: RightAlertButtonType {
        switch self {
        case .logout: return .none
        case .withdraw: return .destructive
        }
    }
}
