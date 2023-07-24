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

    @Binding var text: String

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
        VStack(alignment: .leading) {
            if case let .title(title) = type {
                Text(title)
                    .font(.caption)
            }

            HStack(alignment: .center) {
                TextField(placeholder, text: $text)
                    .font(.body)
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 10, trailing: 0))

                if maxCount > 0 {
                    Text("\(text.count) / \(maxCount)")
                        .foregroundColor(.gray)
                        .font(.callout)
                }

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
            .drawUnderline(color: text.isEmpty ? .gray : .gray.opacity(0.3))
        }
    }
}
