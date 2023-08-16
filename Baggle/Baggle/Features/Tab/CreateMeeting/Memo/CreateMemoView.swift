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
            
            ZStack {
                
                if viewStore.isLoading {
                    LoadingView()
                }
                
                VStack(spacing: 0) {

                    CreateDescription(createStatus: .memo, title: "약속 메모를 남겨보세요.")

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
                    .buttonStyle(BagglePrimaryStyle())
                }
                .padding()
                .touchSpacer()
                .onTapGesture {
                    hideKeyboard()
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewStore.send(.backButtonTapped)
                        } label: {
                            Image.Icon.backTail
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(.closeButtonTapped)
                        } label: {
                            Image.Icon.close
                        }
                    }
                }
                
                if viewStore.isAlertPresented {
                    BaggleAlertOneButton(
                        isPresented: Binding(
                            get: { viewStore.isAlertPresented },
                            set: { _ in viewStore.send(.presentAlert) }
                        ),
                        title: "약속을 잡을 수 없어요!",
                        description: "2시간 이후부터 약속을 잡을 수 있어요.",
                        buttonTitle: "돌아가기") {
                            viewStore.send(.alertButtonTapped)
                        }
                }
            }
        }
    }
}

struct CreateMeetingMemoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMemoView(
            store: Store(
                initialState: CreateMemoFeature.State(
                    meetingCreate: MeetingCreateModel(
                        title: nil,
                        place: nil,
                        time: nil,
                        memo: nil
                    )
                ),
                reducer: CreateMemoFeature()
            )
        )
    }
}
