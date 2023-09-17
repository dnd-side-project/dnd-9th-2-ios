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
    case meetingUnwrapping // 모임 언래핑
    
    case invalidMeetingEdit // 약속 확정 이후 모임 수정 불가 
    
    case meetingDelete // 모임 폭파
    case meetingDelegateFail // 방장 넘기기 불가
    case meetingDelegateSuccess // 방장 넘기기 성공
    
    case meetingLeave // 모임 나가기 (방장 아닌 사람)
    
    case invalidMeetingDelete // 모임 확정 이후에는 폭파, 넘기기, 나가기 불가
    
    case networkError(String) // 네트워크 에러
    case userError // 유저 에러
    case invitation
    case invalidAuthentication // 유효하지 않는 긴급 버튼 인증 시간
}

extension AlertMeetingDetailType: AlertType {

    var buttonType: AlertButtonType {
        switch self {
        case .meetingNotFound,
                .meetingIDError,
                .networkError,
                .userError,
                .invitation,
                .invalidAuthentication,
                .meetingUnwrapping,
                .meetingDelegateFail,
                .meetingDelegateSuccess,
                .invalidMeetingDelete,
                .invalidMeetingEdit
            :
            return .one
        case .meetingDelete:
            return .two(.destructive)
        case .meetingLeave:
            return .two(.none)
        }
    }
    
    var title: String {
        switch self {
        case .meetingNotFound: return "해당하는 모임이 없어요"
        case .meetingIDError: return "모임 정보가 없어요"
        case .meetingUnwrapping: return "모임 정보 에러"
            
        case .invalidMeetingEdit: return "모임 수정 불가"
            
        case .meetingDelete: return "정말 방을 폭파하시겠어요?"
        case .meetingDelegateFail: return "방장 넘기기 불가"
        case .meetingDelegateSuccess: return "방장 넘기기 성공"
            
        case .meetingLeave: return "정말 방을 나가시겠어요?"
            
        case .invalidMeetingDelete: return "모임 나가기 불가"
            
        case .networkError: return "네트워크 에러"
        case .userError: return "유저 정보 에러"
        case .invitation: return "초대"
        case .invalidAuthentication: return "인증 가능한 시간이 아니에요."
        }
    }
    
    var description: String {
        switch self {
        case .meetingNotFound: return "서버에서 모임을 찾을 수 없어요."
        case .meetingIDError: return "홈에서 모임 정보를 전달하는데 실패했어요."
        case .meetingUnwrapping: return "모임 정보를 불러오는데 실패했어요. [언래핑]"
            
        case .invalidMeetingEdit: return "모임 수정은 약속 확정 전에 가능해요."
            
        case .meetingDelegateFail: return "혼자 있을 때는 방장을 넘길 수 없어요."
        case .meetingDelegateSuccess: return "방장을 성공적으로 넘겼어요!"
        case .meetingDelete: return "입력하신 약속정보는 모두 삭제돼요!"
            
        case .meetingLeave: return "이 약속 방의 모든 정보가 사라져요."
            
        case .invalidMeetingDelete: return "약속이 확정된 이후에는 모임을 나갈 수 없어요."
            
        case .networkError(let error): return "네트워크 에러가 발생했어요. 잠시 후 다시 시도해주세요. \(error)"
        case .userError: return "유저 정보를 불러오는데 에러가 발생했어요. 재로그인해주세요."
        case .invitation: return "초대를 할 수가 없어요."
        case .invalidAuthentication: return "인증 가능한 시간에 다시 시도해주세요."
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .meetingNotFound: return "돌아가기"
        case .meetingIDError: return "돌아가기"
        case .meetingUnwrapping: return "확인"
            
        case .invalidMeetingEdit: return "확인"
            
        case .meetingDelete: return "방 폭파하기"
        case .meetingDelegateFail: return "확인"
        case .meetingDelegateSuccess: return "홈으로"
            
        case .meetingLeave: return "나가기"
            
        case .invalidMeetingDelete: return "확인"
            
        case .networkError: return "확인"
        case .userError: return "재로그인"
        case .invitation: return "확인"
        case .invalidAuthentication: return "확인"
        }
    }
}
