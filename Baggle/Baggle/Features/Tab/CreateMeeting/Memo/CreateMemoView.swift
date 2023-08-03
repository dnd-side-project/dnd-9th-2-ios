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
            VStack(spacing: 0) {

                VStack(alignment: .leading, spacing: 16) {
                    PageIndicator(data: CreateStatus.data, selectedStatus: .memo)

                    HStack {
                        Text("약속 메모를 남겨보세요.")
                            .font(.title2)

                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.top)

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
