//
//  CreateMeetingMemoView.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

struct CreateMemoView: View {

    let store: StoreOf<CreateMemoFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack {
                Text("메모를 입력하세요")
                    .font(.largeTitle)

                BaggleTextEditor(
                    store: self.store.scope(
                        state: \.textEditorState,
                        action: CreateMemoFeature.Action.textEditorAction
                    ),
                    title: .title("메모를 입력하세요. (선택)")
                )

                Spacer()

                Button {
                    viewStore.send(.nextButtonTapped)
                } label: {
                    Text("다음")
                }
                .padding(.bottom, 10)
                .buttonStyle(BagglePrimaryStyle())
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

struct CreateMeetingMemoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMemoView(
            store: Store(
                initialState: CreateMemoFeature.State(),
                reducer: CreateMemoFeature()
            )
        )
    }
}
