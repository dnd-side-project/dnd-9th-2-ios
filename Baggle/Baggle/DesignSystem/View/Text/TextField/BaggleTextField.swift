//
//  BaggleTextField.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

import ComposableArchitecture

/**
 - description:

        Baggle Custom TextField 입니다.
    
- note:

        struct ParentFeature: ReducerProtocol {
                
            struct State: Equatable {
                var textFieldState = BaggleTextFieldFeature.State(maxCount: 10,
                                                                  textFieldState: .inactive)
            }
         
            enum Action: Equatable {
                case textFieldAction(BaggleTextFieldFeature.Action)
            }
         
            Scope(state: \.textFieldState, action: /Action.textFieldAction) {
                BaggleTextFieldFeature()
            }
        }
         
         struct ParentView: View {
             let store: StoreOf<ParentFeature>

             var body: some View {
                 WithViewStore(self.store, observe: { $0 }) { viewStore in

                     BaggleTextField(
                         store: self.store.scope(
                         state: \.textFieldState,
                         action: HomeFeature.Action.textFieldAction),
                         placeholder: "place holder"
                     )
                     .padding()
                     
                     // 텍스트 가져오기
                     Text("textField: \(viewStore.textFieldState.text)")
                     
                     Button("에러 띄우기") {
                        // 외부 조건에 따라 상태 바꾸기
                        viewStore.send(.textFieldAction(.changeState(.invalid("그냥 에러입니다"))))
                     }
                 }
             }
         }
 
 */

struct BaggleTextField: View {

    private let store: StoreOf<BaggleTextFeature>
    private var placeholder: String
    private var title: TextFieldTitle
    private var buttonType: TextFieldButton

    @FocusState private var isFocused: Bool

    init(
        store: StoreOf<BaggleTextFeature>,
        placeholder: String = "입력해주세요",
        title: TextFieldTitle = .basic,
        buttonType: TextFieldButton = .delete
    ) {
        self.store = store
        self.placeholder = placeholder
        self.title = title
        self.buttonType = buttonType
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack(alignment: .leading) {

                if case let .title(title) = title {
                    Text(title)
                        .font(.caption)
                        .padding(.horizontal, 2)
                        .padding(.bottom, 6)
                }

                HStack(alignment: .center, spacing: 8) {
                    TextField(placeholder,
                              text: viewStore.binding(
                                get: \.text,
                                send: BaggleTextFeature.Action.textChanged)
                    )
                    .focused($isFocused)
                    .font(.body)
                    .foregroundColor(viewStore.textFieldState.fgColor)

                    Text("\(viewStore.text.count)/\(viewStore.maxCount)")
                        .foregroundColor(viewStore.textFieldState.fgColor)
                        .font(.callout)

                    if viewStore.state.textFieldState == .active {
                        switch buttonType {
                        case .delete:
                            Button {
                                viewStore.send(.textChanged(""))
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(viewStore.textFieldState.fgColor)
                            }

                        case .iconImage(let icon):
                            Image(systemName: icon)
                                .foregroundColor(viewStore.text.isEmpty ? .purple : .gray)
                        }
                    }
                }
                .padding(16)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(viewStore.textFieldState.borderColor))

                if case let .invalid(error) = viewStore.textFieldState {
                    Text(error)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                        .foregroundColor(viewStore.textFieldState.fgColor)
                }
            }
            .onChange(of: self.isFocused) { newValue in
                viewStore.send(.isFocused(newValue))
            }
            .onAppear {
                isFocused = viewStore.state.isFocused
            }
        }
    }
}
