//
//  SsangTextField.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

struct SsangTextField: View {
    private var placeholder: String
    private var type: TextFieldType
    private var title: String?
    private var maxCount: Int = 0
    private var buttonType: TextFieldButton

    @Binding var textfield: String

    init(
        textfield: Binding<String>,
        placeholder: String = "입력해주세요",
        type: TextFieldType = .basic,
        maxCount: Int = 0,
        buttonType: TextFieldButton = .delete
    ) {
        self._textfield = textfield
        self.placeholder = placeholder
        self.type = type
        self.maxCount = maxCount
        self.buttonType = buttonType
    }

    var body: some View {
        VStack(alignment: .leading) {
            if case let .title(str) = type {
                Text(str)
                    .font(.caption)
            }

            HStack(alignment: .center) {
                TextField(placeholder, text: $textfield)
                    .font(.body)
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 10, trailing: 0))

                if maxCount > 0 {
                    Text("\(textfield.count) / \(maxCount)")
                        .foregroundColor(.gray)
                        .font(.callout)
                }

                switch buttonType {
                case .delete:
                    Button {
                        textfield = ""
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }

                case .other(let icon):
                    Image(systemName: icon)
                        .foregroundColor(textfield.isEmpty ? .purple : .gray)
                }
            }
            .drawUnderline(color: textfield.isEmpty ? .gray : .gray.opacity(0.3))
        }
    }
}
