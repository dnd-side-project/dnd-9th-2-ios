//
//  BaggleTextField.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

/**
 - description:

        Baggle Custom TextField 입니다.
 
 - parameters:
    - text: 부모 뷰에서 alert를 보이기 위한 Binding<String> 변수
    - placeholder: 텍스트 입력 전 보여지는 placeholder 문구
    - type:TextFieldTitle 타입 (default: basic, 상단 타이틀X)
    - maxCount: 최대 글자수 (default: 0, 우측 글자수 카운트 X)
    - buttonType: 우측 버튼 타입 (default: .delete)
    
- note:
 
        @State var text: String = ""
 
        var body: some View {
            BaggleTextField(text: $text)
        }
 */

struct BaggleTextField: View {

    private var placeholder: String
    private var type: TextFieldTitle
    private var maxCount: Int = 0
    private var buttonType: TextFieldButton

    @Binding private var text: String
    @State private var state: TextFieldState = .inactive
    @FocusState private var isFocused: Bool

    init(
        text: Binding<String>,
        placeholder: String = "입력해주세요",
        type: TextFieldTitle = .basic,
        maxCount: Int = 0,
        buttonType: TextFieldButton = .delete
    ) {
        self._text = text
        self.placeholder = placeholder
        self.type = type
        self.maxCount = maxCount
        self.buttonType = buttonType
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if case let .title(title) = type {
                Text(title)
                    .font(.caption)
                    .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 0))
            }

            HStack(alignment: .center) {
                TextField(placeholder, text: $text, onEditingChanged: { editingChanged in
                    if editingChanged {
                        state = .active
                    } else {
                        state = text.isEmpty ? .inactive : .fill
                    }
                })
                .focused($isFocused)
                .font(.body)
                .foregroundColor(state.fgColor)

                if maxCount > 0 && state != .fill {
                    Text("\(text.count)/\(maxCount)")
                        .foregroundColor(state.fgColor)
                        .font(.callout)
                }

                if state == .active {
                    switch buttonType {
                    case .delete:
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }

                    case .iconImage(let icon):
                        Image(systemName: icon)
                            .foregroundColor(text.isEmpty ? .purple : .gray)
                    }
                }
            }
            .padding(EdgeInsets(top: 18.5, leading: 16, bottom: 18.5, trailing: 16))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(state.borderColor))
        }
        .onChange(of: self.text) { _ in
            if text.count > maxCount {
                text = String(text.prefix(maxCount))
            }
        }
    }
}
