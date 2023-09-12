//
//  AlertMeetingEditType.swift
//  Baggle
//
//  Created by youtak on 2023/09/12.
//

import Foundation

enum AlertMeetingEditType: Equatable {
    case invalidMeetingTime // 모임 시간 < 현재 시간 + 1시간
    
    case failCreateMeetingEdit // 모임 수정 모델 생성 에러
    case meetingNotFound // 404 에러
    case networkError(String) // 네트워크 에러
    case userError // 유저 에러
}

extension AlertMeetingEditType: AlertType {
    
    var buttonType: AlertButtonType {
        switch self {
        case .invalidMeetingTime,
                .failCreateMeetingEdit,
                .meetingNotFound,
                .networkError,
                .userError:
            return .one
        }
    }
    
    var title: String {
        switch self {
        case .invalidMeetingTime: return "모임 수정 불가"
        case .failCreateMeetingEdit: return "모임 수정 에러"
        case .meetingNotFound: return "해당하는 모임이 없어요"
        case .networkError: return "네트워크 에러"
        case .userError: return "유저 정보 에러"
        }
    }
    
    var description: String {
        switch self {
        case .invalidMeetingTime: return "모임 시간은 1시간 이후부터 가능해요"
        case .failCreateMeetingEdit: return "모임 수정 모델을 만드는 데 실패했어요. 잠시 후 재시도해주세요."
        case .meetingNotFound: return "서버에서 모임을 찾을 수 없어요."
        case .networkError(let error): return "네트워크 에러가 발생했어요. 잠시 후 다시 시도해주세요. \(error)"
        case .userError: return "유저 정보를 불러오는데 에러가 발생했어요. 재로그인해주세요."
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .invalidMeetingTime: return "확인"
        case .failCreateMeetingEdit: return "확인"
        case .meetingNotFound: return "돌아가기"
        case .networkError: return "확인"
        case .userError: return "재로그인"
        }
    }
}
