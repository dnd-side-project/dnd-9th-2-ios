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
    - title: TextFieldTitle 타입 (default: basic, 상단 타이틀X)
    - state: TextFieldState 타입 (초기 inactive 설정 필요)
    - maxCount: 최대 글자수 (default: 0, 우측 글자수 카운트 X)
    - buttonType: 우측 버튼 타입 (default: .delete)
    
- note:
 
        @State var text: String = ""
        @State var textFieldState: TextFieldState = .inactive
        
        textFieldState = .invalid("에러메세지를 넣어주세요")
        
        var body: some View {
            BaggleTextField(text: $text, state: $textFieldState)
 
            BaggleTextField(text: $text,
                            state: $textFieldState,
                            title: .title("어떤 약속인가요?"),
                            maxCount: 10)
        }
 */

struct BaggleTextField: View {

    private var placeholder: String
    private var title: TextFieldTitle
    private var maxCount: Int = 0
    private var buttonType: TextFieldButton

    @Binding private var text: String
    @Binding private var state: TextFieldState
    @FocusState private var isFocused: Bool

    init(
        text: Binding<String>,
        placeholder: String = "입력해주세요",
        state: Binding<TextFieldState>,
        title: TextFieldTitle = .basic,
        maxCount: Int = 0,
        buttonType: TextFieldButton = .delete
    ) {
        self._text = text
        self.placeholder = placeholder
        self._state = state
        self.title = title
        self.maxCount = maxCount
        self.buttonType = buttonType
    }

    var body: some View {
        VStack(alignment: .leading) {
            if case let .title(title) = title {
                Text(title)
                    .font(.caption)
                    .padding(EdgeInsets(top: 0, leading: 2, bottom: 6, trailing: 0))
            }

            HStack(alignment: .center, spacing: 8) {
                TextField(placeholder, text: $text, onEditingChanged: { editingChanged in
                    if editingChanged {
                        state = .active
                    } else {
                        state = text.isEmpty ? .inactive : .valid
                    }
                })
                .focused($isFocused)
                .font(.body)
                .foregroundColor(state.fgColor)

                if maxCount > 0 {
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
                                .foregroundColor(state.fgColor)
                        }

                    case .iconImage(let icon):
                        Image(systemName: icon)
                            .foregroundColor(text.isEmpty ? .purple : .gray)
                    }
                }
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(state.borderColor))

            if case let .invalid(error) = state {
                Text(error)
                    .font(.caption)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 0))
                    .foregroundColor(state.fgColor)
            }
        }
        .onChange(of: self.text) { _ in
            if text.count > maxCount {
                text = String(text.prefix(maxCount))
            }
        }
    }
}
