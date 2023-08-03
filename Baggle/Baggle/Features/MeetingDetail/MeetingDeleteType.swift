//
//  MeetingDeleteType.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/03.
//

import Foundation

enum MeetingDeleteType {
    case leave
    case delete

    var title: String {
        switch self {
        case .leave: return " 방을 나가시겠습니까?"
        case .delete: return " 방을 정말 폭파하시겠습니까?"
        }
    }

    var description: String {
        switch self {
        case .leave: return ""
        case .delete: return "방을 폭파하면 다시 되돌릴 수 없어요"
        }
    }

    var rightButtonTitle: String {
        switch self {
        case .leave: return "나가기"
        case .delete: return "폭파하기"
        }
    }
}
