//
//  HomeStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/08.
//

import Foundation

enum HomeStatus {
    case loading
    case empty
    case error
    case normal

    var title: String? {
        switch self {
        case .loading: return "약속 목록을 로딩중입니다.."
        case .empty: return "아직 예정된 약속이 없어요!"
        case .error: return "오류가 발생하여 모임 조회를 할 수 없어요"
        case .normal: return .none
        }
    }

    var description: String? {
        switch self {
        case .loading: return .none
        case .empty: return "아래 '+' 버튼을 눌러 약속을 만들어보세요"
        case .error: return "화면을 아래로 스크롤하여 연결을 시도할 수 있어요"
        case .normal: return .none
        }
    }
}
