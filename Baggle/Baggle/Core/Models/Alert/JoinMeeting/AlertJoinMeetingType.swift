//
//  AlertJoinMeetingType.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/22.
//

import Foundation


enum AlertJoinMeetingType: Equatable {
    case expired
    case overlap
    case exceedMemberCount
}

extension AlertJoinMeetingType: AlertType {
    var buttonType: AlertButtonType {
        switch self {
        case .expired, .overlap, .exceedMemberCount:
            return .one
        }
    }
    
    var title: String {
        switch self {
        case .expired:
            return "이미 만료된 방이에요!"
        case .overlap:
            return "기존 모임 시간과 중복됩니다."
        case .exceedMemberCount:
            return "참여 가능한 인원을 초과했어요!"
        }
    }
    
    var description: String {
        switch self {
        case .expired:
            return "약속 1시간 전까지만 입장이 가능해요."
        case .overlap:
            return "약속 2시간 전후로 이미 모임이 존재합니다."
        case .exceedMemberCount:
            return "참여 가능한 인원은 최대 6명입니다."
        }
    }
    
    var buttonTitle: String {
        return "확인"
    }
}
