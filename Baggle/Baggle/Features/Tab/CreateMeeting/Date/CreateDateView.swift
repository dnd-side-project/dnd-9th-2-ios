//
//  CreateMeetingDateView.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

struct CreateDateView: View {
    
    private let dateButtonSpace: CGFloat = 10
    private let dateWidthRatio = 0.65
    private let dateButtonHeight: CGFloat = 54
    
    let store: StoreOf<CreateDateFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            VStack(spacing: 0) {

                CreateDescription(createStatus: .date, title: "언제 만나기로 했나요?")

                VStack(alignment: .leading) {
                    
                    Text("날짜와 시간을 입력하세요.")
                        .font(.Baggle.description2)
                        .foregroundColor(.gray6)
                        .padding(.horizontal, 2)
                    
                   MeetingDateButton(
                        store: self.store.scope(
                            state: \.meetingDateButtonState,
                            action: CreateDateFeature.Action.meetingDateButtonAction
                        ),
                        meetingDate: viewStore.binding(
                            get: \.meetingDate,
                            send: { value in
                                CreateDateFeature.Action.dateChanged(value)
                            }
                        )
                   )
                    
                    if let errorMessage = viewStore.errorMessage {
                        Text(errorMessage)
                            .font(.Baggle.caption3)
                            .foregroundColor(.baggleRed)
                            .padding(.horizontal, 2)
                    }
                }
                
                Spacer()
                
                Button {
                    viewStore.send(.nextButtonTapped)
                } label: {
                    Text("다음")
                }
                .buttonStyle(BagglePrimaryStyle())
                .disabled(viewStore.buttonDisabled)
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewStore.send(.onAppear)
            }
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
            .sheet(
                store: self.store.scope(
                    state: \.$selectDateState,
                    action: { .selectDateAction($0) })
            ) { selectDateStore in
                SelectDateView(store: selectDateStore)
                    .presentationDetents([.height(360)])
            }
            .sheet(
                store: self.store.scope(
                    state: \.$selectTimeState,
                    action: { .selectTimeAction($0) })
            ) { selectTimeStore in
                SelectTimeView(store: selectTimeStore)
                    .presentationDetents([.height(360)])
            }
        }
    }
}

extension CreateDateView {
    private func dateWidth(_ containerWidth: CGFloat) -> CGFloat {
        abs(containerWidth - dateButtonSpace) * dateWidthRatio
    }
    
    private func timerWidth(_ containerWidth: CGFloat) -> CGFloat {
        abs(containerWidth - dateButtonSpace) * (1 - dateWidthRatio)
    }
}

struct CreateDateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDateView(
            store: Store(
                initialState: CreateDateFeature.State(
                    meetingDateButtonState: MeetingDateButtonFeature.State()
                ),
                reducer: CreateDateFeature()
            )
        )
    }
}
