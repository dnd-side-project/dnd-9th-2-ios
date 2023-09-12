//
//  MeetingEditView.swift
//  Baggle
//
//  Created by youtak on 2023/08/31.
//

import SwiftUI

import ComposableArchitecture

struct MeetingEditView: View {
    
    let store: StoreOf<MeetingEditFeature>
    let scrollTopID: String = "scrollTopID"
    let scrollBottomID: String = "scrollBottomID"
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    
                    VStack {
                        HStack {
                            Text("약속 정보 수정하기")
                                .font(.baggleFont(fontType: .subTitle1))
                            
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .id(scrollTopID)
                        
                        
                        VStack(spacing: 20) {
                            BaggleTextField(
                                store: self.store.scope(
                                    state: \.titleTextFieldState,
                                    action: MeetingEditFeature.Action.titleTextFieldAction
                                ),
                                placeholder: "ex. 종강 파티",
                                title: .title("약속명")
                            )
                            
                            BaggleTextField(
                                store: self.store.scope(
                                    state: \.placeTextFieldState,
                                    action: MeetingEditFeature.Action.placeTextFieldAction
                                ),
                                placeholder: "ex. 성수역 2번 출구",
                                title: .title("약속 장소")
                            )
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("날짜와 시간")
                                    .font(.Baggle.description2)
                                    .padding(.horizontal, 2)
                                    .padding(.bottom, 8)
                                    .foregroundColor(.gray6)
                                
                                MeetingDateButton(
                                    store: self.store.scope(
                                        state: \.meetingDateButtonState,
                                        action: MeetingEditFeature.Action.meetingDateButtonAction
                                    ),
                                    meetingDate: viewStore.binding(
                                        get: \.meetingEdit.date,
                                        send: { value in
                                            MeetingEditFeature.Action.dateChanged(value)
                                        }
                                    )
                                )
                            }
                            
                            BaggleTextEditor(
                                store: self.store.scope(
                                    state: \.memoTextEditorState,
                                    action: MeetingEditFeature.Action.memoTextEditorAction
                                ),
                                title: .title("메모(선택)")
                            )
                            
                            Button {
                                viewStore.send(.editButtonTapped)
                            } label: {
                                Text("수정하기")
                            }
                            .buttonStyle(BagglePrimaryStyle())
                            .padding(.vertical, 20)
                            .disabled(viewStore.editButtonDisabled)
                            .id(scrollBottomID)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .onChange(of: viewStore.memoTextEditorFocused) { isFocused in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                if isFocused {
                                    scrollViewProxy.scrollTo(scrollBottomID)
                                } else {
                                    scrollViewProxy.scrollTo(scrollTopID)
                                }
                            }
                        }
                }
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewStore.send(.backButtonTapped)
                    } label: {
                        Image.Icon.backTail
                    }
                }
            }
            .touchSpacer()
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .baggleAlert(
                isPresented: viewStore.binding(
                    get: { $0.isAlertPresented },
                    send: { MeetingEditFeature.Action.presentAlert($0) }
                ),
                alertType: viewStore.alertType,
                action: { viewStore.send(.alertButtonTapped) }
            )
            .sheet(
                store: self.store.scope(
                    state: \.$selectDateState,
                    action: { .selectDateAction($0) }
                )
            ) { selectDateStore in
                SelectDateView(store: selectDateStore)
                    .presentationDetents([.height(360)])
            }
            .sheet(
                store: self.store.scope(
                    state: \.$selectTimeState,
                    action: { .selectTimeAction($0) }
                )
            ) { selectTimeStore in
                SelectTimeView(store: selectTimeStore)
                    .presentationDetents([.height(360)])
            }
        }
    }
}

struct MeetingEditView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingEditView(
            store: Store(
                initialState: MeetingEditFeature.State(
                    beforeMeetingEdit: MeetingEditModel(
                        id: 0,
                        title: "제목",
                        place: "장소는 어디냐",
                        date: Date(),
                        memo: "메모메모"
                    ),
                    meetingEdit: MeetingEditModel(
                        id: 0,
                        title: "제목",
                        place: "장소는 어디냐",
                        date: Date(),
                        memo: "메모메모"
                    ),
                    meetingDateButtonState: MeetingDateButtonFeature.State()
                ),
                reducer: MeetingEditFeature()
            )
        )
    }
}
