//
//  BaggleTextField.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

struct BaggleTextField: View {
    private var placeholder: String
    private var type: TextFieldTitle
    private var title: String?
    private var maxCount: Int = 0
    private var buttonType: TextFieldButton

    @Binding var text: String

    init(
        textfield: Binding<String>,
        placeholder: String = "입력해주세요",
        type: TextFieldTitle = .basic,
        maxCount: Int = 0,
        buttonType: TextFieldButton = .delete
    ) {
        self._text = textfield
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
