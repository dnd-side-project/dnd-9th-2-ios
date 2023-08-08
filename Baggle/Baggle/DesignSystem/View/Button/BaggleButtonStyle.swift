//
//  BaggleButtonStyle.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

/**
 - description:

            Baggle 앱에서 사용하는 Button Style 입니다.
 
 - parameters:
    - size: 버튼 사이즈
    - shape: 버튼 모양 (네모 or 둥그럼)
    
- note:
 
        기본 사용법
 
        Button {
            //...
        }
        .buttonStyle(BagglePrimaryStyle())
        
 
        size와 shape 설정시
         
        Button {
             //...
         }
         .buttonStyle(BagglePrimaryStyle(size: .medium, shape: .round))
 
 */

struct BagglePrimaryStyle: ButtonStyle {

    private let size: ButtonSize
    private let shape: ButtonShape

    private let foregroundColor: Color = .white
    private let backgroundColor: Color = .primaryNormal

    init(size: ButtonSize = .large, shape: ButtonShape = .square) {
        self.size = size
        self.shape = shape
    }

    @Environment(\.isEnabled) private var isEnabled

    private func foregroundColor(_ isPressed: Bool) -> Color {
        if !isEnabled {
            return foregroundColor
        } else if isPressed {
            return foregroundColor.opacity(0.5)
        } else {
            return foregroundColor
        }
    }

    private func backgroundColor(_ isPressed: Bool) -> Color {
        if !isEnabled {
            return Color.gray // 디자인 확정 시 수정
        } else if isPressed {
            return backgroundColor.opacity(0.5)
        } else {
            return backgroundColor
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.width * size.ratio, height: 54)
            .foregroundColor(foregroundColor(configuration.isPressed))
            .background(backgroundColor(configuration.isPressed))
            .cornerRadius(shape.radius)
    }
}

struct BaggleSecondaryStyle: ButtonStyle {

    private let foregroundColor: Color = .white
    private let backgroundColor: Color = .black
    var buttonType: MeetingDetailButtonType = .none // authorize 타입 외 모두 스타일 동일

    @Environment(\.isEnabled) private var isEnabled

    private func foregroundColor(_ isPressed: Bool) -> Color {
        if !isEnabled {
            return foregroundColor
        } else if isPressed {
            return foregroundColor.opacity(0.5)
        } else {
            return foregroundColor
        }
    }

    private func backgroundColor(_ isPressed: Bool) -> Color {
        if !isEnabled {
            return Color.gray // 디자인 확정 시 수정
        } else if isPressed {
            return backgroundColor.opacity(0.5)
        } else {
            return backgroundColor
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 54)
            .padding(.leading, buttonType == .authorize ? 24 : 34)
            .padding(.trailing, buttonType == .authorize ? 16 : 36)
            .foregroundColor(foregroundColor(configuration.isPressed))
            .background(backgroundColor(configuration.isPressed))
            .cornerRadius(54/2)
    }
}
