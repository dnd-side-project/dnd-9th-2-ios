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
                .baggleAlert(
                    isPresented: viewStore.binding(
                        get: { $0.isAlertPresented },
                        send: { CreateMemoFeature.Action.presentAlert($0) }
                    ),
                    alertType: viewStore.alertType,
                    action: { viewStore.send(.alertButtonTapped) }
                )
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
