//
//  AlertSignUpType.swift
//  Baggle
//
//  Created by youtak on 2023/09/07.
//

import Foundation

enum AlertSignUpType: Equatable {
    case networkError(String) // 네트워크 에러
    case userError // 유저 정보 로컬 저장 에러
}

extension AlertSignUpType: AlertType {

    var buttonType: AlertButtonType {
        switch self {
        case .networkError, .userError:
            return .one
        }
    }
    
    var title: String {
        switch self {
        case .networkError: return "네트워크 에러"
        case .userError: return "유저 정보 저장 에러"
        }
    }
    
    var description: String {
        switch self {
        case .networkError(let description): return "네트워크 에러가 발생했어요. 다시 시도해주세요. \(description)"
        case .userError: return "로컬에 유저 정보를 저장하는데 에러가 발생했어요. 지속적으로 에러 발생 시 앱을 재시작해주세요."
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .networkError: return "확인"
        case .userError: return "확인"
        }
    }
}
