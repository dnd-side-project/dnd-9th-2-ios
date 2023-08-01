//
//  BaggleTextEditor.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct BaggleTextEditor: View {

    let store: StoreOf<BaggleTextFeature>
    private var title: TextFieldTitle
    private var placeholder: String

    init(store: StoreOf<BaggleTextFeature>, title: TextFieldTitle, placeholder: String) {
        self.store = store
        self.title = title
        self.placeholder = placeholder
    }

    @FocusState private var isFocused: Bool

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

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
                    TextEditor(
                        text: viewStore.binding(
                            get: \.text,
                            send: BaggleTextFeature.Action.textChanged
                        )
                    )
                        .lineSpacing(5)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 120)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(viewStore.textFieldState.fgColor, lineWidth: 1)
                        )
                        .focused($isFocused)
                        .onChange(of: isFocused) { newValue in
                            viewStore.send(.isFocused(newValue))
                        }

                    Text("\(viewStore.text.count) / 50")
                        .foregroundColor(viewStore.textFieldState.borderColor)
                        .padding()
                }

                // MARK: - 에러메시지

                if case let .invalid(error) = viewStore.textFieldState {
                    Text(error)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                        .foregroundColor(viewStore.textFieldState.fgColor)
                }
            }
            .padding()
        }
    }
}

struct BaggleTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        BaggleTextEditor(
            store: Store(
                initialState: BaggleTextFeature.State(maxCount: 50, textFieldState: .inactive),
                reducer: BaggleTextFeature()
            ),
            title: .title("메모를 입력하세요. (선택)"),
            placeholder: "ex. 오늘 성수 뿌셔!"
        )
    }
}
