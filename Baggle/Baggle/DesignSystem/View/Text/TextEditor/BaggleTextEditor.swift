//
//  BaggleTextEditor.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct BaggleTextEditor: View {

    private let store: StoreOf<BaggleTextFeature>
    @State private var placeholder: String
    private var title: TextFieldTitle

    init(
        store: StoreOf<BaggleTextFeature>,
        placeholder: String = "ex. 오늘 성수 뿌셔",
        title: TextFieldTitle = .basic
    ) {
        self.store = store
        self.placeholder = placeholder
        self.title = title
    }

    @FocusState private var isFocused: Bool

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack(alignment: .leading) {

                // MARK: - 제목
                if case let .title(title) = title {
                    Text(title)
                        .font(.Baggle.body3)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 6)
                        .foregroundColor(.gray6)
                }

                // MARK: - 본문

                ZStack(alignment: .bottomTrailing) {

                    ZStack(alignment: .topLeading) {
                        TextEditor(
                            text: viewStore.binding(
                                get: \.text,
                                send: BaggleTextFeature.Action.textChanged
                            )
                        )
                        .font(.Baggle.body2)
                        .foregroundColor(viewStore.textFieldState.fgColor)
                        .background(.clear)
                        .lineSpacing(5)
                        .padding()
                        .focused($isFocused)
                        .onChange(of: isFocused) { newValue in
                            viewStore.send(.isFocused(newValue))
                        }

                        if viewStore.text.isEmpty && !isFocused {
                            TextEditor(text: $placeholder)
                                .font(.Baggle.body2)
                                .font(.body)
                                .foregroundColor(.gray)
                                .disabled(true)
                                .padding()
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 140, maxHeight: 140)

                    Text("\(viewStore.text.count) / 50")
                        .font(.Baggle.body2)
                        .foregroundColor(viewStore.textFieldState.fgColor)
                        .padding()
                }
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewStore.textFieldState.fgColor, lineWidth: 1)
                )

                // MARK: - 에러메시지

                if case let .invalid(error) = viewStore.textFieldState {
                    Text(error)
                        .font(.Baggle.caption3)
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                        .foregroundColor(viewStore.textFieldState.fgColor)
                }
            }
            .onAppear {
                isFocused = viewStore.state.isFocused
            }
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
            placeholder: "ex. 오늘 성수 뿌셔!",
            title: .title("메모를 입력하세요. (선택)")
        )
    }
}
