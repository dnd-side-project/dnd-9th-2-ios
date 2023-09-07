//
//  AlertCreateMeetingType.swift
//  Baggle
//
//  Created by youtak on 2023/08/17.
//

import Foundation

enum AlertCreateMeetingType: Equatable {
    case forbiddenMeetingTime // 약속 2시간 전이 아님
    case duplicatedMeeting // 2시간 전 후 중복된 모임
    case networkError(String) // 네트워크 에러
    case userError // 유저 에러
    case requestModelError // 모델 생성 에러
}

extension AlertCreateMeetingType: AlertType {
    
    var buttonType: AlertButtonType { return .one }

    var title: String {
        switch self {
        case .forbiddenMeetingTime: return "약속을 잡을 수 없어요!"
        case .duplicatedMeeting: return "약속을 잡을 수 없어요!"
        case .networkError: return "네트워크 에러"
        case .userError: return "유저 정보 에러"
        case .requestModelError: return "모임 생성 에러"
        }
    }
    
    var description: String {
        switch self {
        case .forbiddenMeetingTime: return "2시간 이후부터 약속을 잡을 수 있어요."
        case .duplicatedMeeting: return "설정한 모임 시간 기준 전후 2시간 이내에 이미 약속이 있어요."
        case .networkError(let error): return "네트워크 에러가 발생했어요. 잠시 후 다시 시도해주세요. \(error)"
        case .userError: return "유저 정보를 불러오는데 에러가 발생했어요. 재로그인 해주세요."
        case .requestModelError: return "모임을 생성하는데 에러가 발생했어요. 다시 시도해주세요."
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .forbiddenMeetingTime: return "돌아가기"
        case .duplicatedMeeting: return "돌아가기"
        case .networkError: return "확인"
        case .userError: return "재로그인"
        case .requestModelError: return "홈 화면으로 돌아가기"
        }
    }
}
