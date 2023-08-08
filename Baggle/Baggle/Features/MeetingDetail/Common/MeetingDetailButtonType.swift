//
//  MeetingDetailButtonType.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/08.
//

import SwiftUI

enum MeetingDetailButtonType {
    case emergency
    case invite
    case authorize
    case none
}

extension MeetingDetailButtonType {
    var buttonTitle: String {
        switch self {
        case .emergency: return "참여자 호출하기"
        case .invite: return "초대장 보내기"
        case .authorize: return "사진 인증하기"
        case .none: return ""
        }
    }

    var buttonIcon: Image? {
        switch self {
        case .emergency: return Image.Icon.siren
        case .invite: return Image.Icon.letter
        case .authorize: return Image.Icon.cameraColor
        case .none: return .none
        }
    }
}
