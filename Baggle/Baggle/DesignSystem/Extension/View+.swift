//
//  attributedString.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/24.
//

import SwiftUI

extension View {
    
    // MARK: - Screen Size
    
    var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }

    // MARK: - Attirbuted String

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

    // MARK: - keyboard

    /**
     - description:
        키보드를 숨겨주는 메소드

     
     - note:
     
        .onTapGesture {
            hideKeyboard()
        }
     */

    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

// MARK: - Error Alert

extension View {
    func errorAlert(
        isPresented: Binding<Bool>,
        description: String,
        action: @escaping () -> Void
    ) -> some View {
        BaggleAlertOneButton(
            isPresented: isPresented,
            title: "에러가 발생했어요",
            description: description,
            buttonTitle: "돌아가기") {
                action()
            }
    }
}

// MARK: - ActionSheet

extension View {
    @ViewBuilder func presentActionSheet (
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                ShadeView(isPresented: isPresented)
                
                BaggleActionSheet(isShowing: isPresented, action: content)
            }
        }
    }
    
    func addAction(_ action: @escaping () -> Void, role: ButtonRole? = nil) -> Button<Self> {
        Button(role: role) {
            action()
            postObserverAction(.actionSheetDismiss)
        } label: {
            self
        }
    }
}
