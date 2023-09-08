//
//  AlertJoinMeetingType.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/22.
//

import Foundation


enum AlertJoinMeetingType: Equatable {
    case expired // 초대가 만료된 방
    case overlap // 모임 시간 중복
    case exceedMemberCount // 모임 최대 멤버수 초과
    case networkError(String)
    case userError
}

extension AlertJoinMeetingType: AlertType {
    var buttonType: AlertButtonType {
        switch self {
        case .expired, .overlap, .exceedMemberCount, .networkError, .userError:
            return .one
        }
    }
    
    var title: String {
        switch self {
        case .expired: return "이미 만료된 방이에요!"
        case .overlap: return "기존 모임 시간과 중복됩니다."
        case .exceedMemberCount: return "참여 가능한 인원을 초과했어요!"
        case .networkError: return "네트워크 에러"
        case .userError: return "유저 에러"
        }
    }
    
    var description: String {
        switch self {
        case .expired: return "약속 1시간 전까지만 입장이 가능해요."
        case .overlap: return "약속 2시간 전후로 이미 모임이 존재합니다."
        case .exceedMemberCount: return "참여 가능한 인원은 최대 6명입니다."
        case .networkError(let description):
            return "네트워크 에러가 발생했어요.\n잠시 후 다시 시도해주세요. \(description)"
        case .userError: return "로컬 유저 정보를 불러오는데 에러가 발생했어요. 재로그인해주세요."
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .expired, .overlap, .exceedMemberCount, .networkError: return "확인"
        case .userError: return "재로그인"
        }
    }
}
