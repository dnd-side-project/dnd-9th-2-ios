//
//  attributedString.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/24.
//

import SwiftUI

/**
 - description:
        
        특정 문자열에만 다른 폰트 스타일을 지정해주는 메서드입니다.
        - attributedColorString: 색상 변경
        - attributedFontString: 폰트 변경
 
 - parameters:
    - fullStr: 전체 문자열
    - targetStr : 다른 폰트 스타일을 적용할 특정 문자열
    - fullColor : 전체 문자열의 기본 색상
    - targetColor : 특정 문자열에 적용할 색상
    - fullFont : 전체 문자열의 기본 폰트
    - targetFont : 특정 문자열에 적용될 폰트
 
 - note:
 
     Text(attributedColorString(str: "Home View 입니다",
                                targetStr: "Home View",
                                color: .black,
                                targetColor: .blue))
 
     Text(attributedFontString(str: "Home View 입니다",
                               targetStr: "Home View",
                               font: .body,
                               targetFont: .headline))
 */

extension View {
    func attributedColorString(
        str: String,
        targetStr: String,
        color: Color,
        targetColor: Color
    ) -> AttributedString {
        var attributedString: AttributedString {
            var text: AttributedString = AttributedString(str)
            if let targetRange = text.range(of: targetStr) {
                text.foregroundColor = color
                text[targetRange].foregroundColor = targetColor
            }
            return text
        }
        return attributedString
    }

    func attributedFontString(
        str: String,
        targetStr: String,
        font: Font,
        targetFont: Font
    ) -> AttributedString {
        var attributedString: AttributedString {
            var text: AttributedString = AttributedString(str)
            if let targetRange = text.range(of: targetStr) {
                text.font = font
                text[targetRange].font = targetFont
            }
            return text
        }
        return attributedString
    }
}
