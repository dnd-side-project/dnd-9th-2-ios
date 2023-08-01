//
//  BaggleTextEditor.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

struct BaggleTextEditor: View {

    private var title: TextFieldTitle
    private var placeholder: String

    init(title: TextFieldTitle, placeholder: String) {
        self.title = title
        self.placeholder = placeholder
    }

    @State private var inputText = ""
    @State private var wordCount = 0
    @State private var textFieldState: TextFieldState = .inactive
    @FocusState private var isFocused: Bool

    var body: some View {

        VStack(alignment: .leading) {

            // MARK: - 제목
            if case let .title(title) = title {
                Text(title)
                    .font(.caption)
                    .padding(.horizontal, 2)
                    .padding(.bottom, 6)
            }

            // MARK: - 본문

            ZStack(alignment: .bottomTrailing) {
                TextEditor(text: $inputText)
                    .lineSpacing(5)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 120)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(textFieldState.borderColor, lineWidth: 1)
                    )
                    .focused($isFocused)
                    .onChange(of: inputText) { newValue in
                        wordCount = newValue.count
                    }
                    .onChange(of: isFocused) { isFocused in
                        textFieldState = isFocused ? .active : .inactive
                    }

                Text("\(wordCount) / 50")
                    .foregroundColor(textFieldState.borderColor)
                    .padding()
            }

            // MARK: - 에러메시지

            if case let .invalid(error) = textFieldState {
                Text(error)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                    .foregroundColor(textFieldState.fgColor)
            }
        }
        .padding()
    }
}

struct BaggleTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        BaggleTextEditor(
            title: .title("메모를 입력하세요. (선택)"),
            placeholder: "ex. 오늘 성수 뿌셔!"
        )
    }
}
