//
//  HomeStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/08.
//

import SwiftUI

enum HomeStatus {
    case loading
    case empty
    case error
    case normal

    var title: String? {
        switch self {
        case .loading: return "약속 목록을 로딩중입니다."
        case .empty: return "아직 약속이 없어요!"
        case .error: return "오류가 발생하여 약속을 볼 수 없어요."
        case .normal: return .none
        }
    }

    var description: String? {
        switch self {
        case .loading: return .none
        case .empty: return "아래 '+' 버튼을 눌러 약속을 만들어보세요."
        case .error: return "화면을 아래로 스크롤하여 연결을 시도해 보세요."
        case .normal: return .none
        }
    }
    
    var image: Image? {
        switch self {
        case .loading: return Image.Background.loading
        case .empty: return Image.Background.empty
        case .error: return Image.Background.error
        case .normal: return .none
        }
    }
    
    var ratio: CGFloat {
        switch self {
        case .loading: return 0.26
        case .empty: return 0.2
        case .error: return 0.27
        case .normal: return .zero
        }
    }
}
