//
//  AlertMeetingDetailType.swift
//  Baggle
//
//  Created by youtak on 2023/08/17.
//

import Foundation

enum AlertMeetingDetailType: Equatable {
    case meetingNotFound // 존재하지 않는 모임
    case meetingIDError // 홈 -> 모임 상세에서 nil 값 전달
    case networkError(String) // 네트워크 에러
    case userError // 유저 에러
    case invitation

    case delete
}

extension AlertMeetingDetailType {

    var buttonType: AlertButtonType {
        switch self {
        case .meetingNotFound, .meetingIDError, .networkError, .userError, .invitation:
            return .one
        case .delete:
            return .two
        }
    }
    
    var title: String {
        switch self {
        case .meetingNotFound: return "해당하는 모임이 없어요"
        case .meetingIDError: return "모임 정보가 없어요"
        case .networkError: return "네트워크 에러"
        case .userError: return "유저 정보 에러"
        case .invitation: return "초대"
        case .delete: return "정말 방을 폭파하시겠어요?"
        }
    }
    
    var description: String {
        switch self {
        case .meetingNotFound: return "서버에서 모임을 찾을 수 없어요."
        case .meetingIDError: return "홈에서 모임 정보를 전달하는데 실패했어요."
        case .networkError(let error): return "네트워크 에러가 발생했어요. 잠시 후 다시 시도해주세요. \(error)"
        case .userError: return "유저 정보를 불러오는데 에러가 발생했어요. 앱 종료 후 다시 시작해주세요."
        case .invitation: return "초대를 할 수가 없어요."
        case .delete: return "입력하신 약속정보는 모두 삭제돼요!"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .meetingNotFound: return "돌아가기"
        case .meetingIDError: return "돌아가기"
        case .networkError: return "확인"
        case .userError: return "앱 종료"
        case .invitation: return "확인"
        case .delete: return "폭파하기"
        }
    }
}
