//
//  SsangTextFieldType.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import Foundation

/// 상단 타이틀 유무에 따른 TextFieldType
enum TextFieldType {
    case basic // 상단 타이틀 X (default)
    case title(String) // 상단 타이틀 O
}

/// 사용 가능 여부에 따른 TextFieldState
/// - 추후 디자인 반영 수정
enum TextFieldState {
    case inactive
    case active
}

/// 우측 버튼에 따른 TextFieldButton
enum TextFieldButton {
    case delete // 텍스트 삭제 버튼 (default)
    case other(String) // 그 외 아이콘 string 값을 직접 받아 커스텀할 버튼
}
