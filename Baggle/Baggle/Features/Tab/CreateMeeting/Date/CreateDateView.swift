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

                GeometryReader { proxy in
                    VStack(alignment: .leading) {

                        Text("날짜와 시간을 입력하세요.")
                            .font(.Baggle.description2)
                            .foregroundColor(.gray6)
                            .padding(.horizontal, 2)
                        
                        HStack(spacing: dateButtonSpace) {
                            
                            // MARK: - Date Button

                            HStack {
                                Text(viewStore.meetingDate.koreanDate())
                                    .font(.Baggle.body2)
                                Spacer()
                            }
                            .foregroundColor(viewStore.dateButtonStatus.foregroundColor)
                            .padding()
                            .frame(width: dateWidth(proxy.size.width))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewStore.dateButtonStatus.borderColor, lineWidth: 1)
                            )
                            .touchSpacer()
                            .onTapGesture {
                                viewStore.send(.selectDateButtonTapped)
                            }

                            // MARK: - Time Button
                            
                            HStack {
                                Text(viewStore.meetingDate.hourMinute())
                                    .font(.Baggle.body2)
                                Spacer()
                            }
                            .foregroundColor(viewStore.timeButtonStatus.foregroundColor)
                            .padding()
                            .frame(width: timerWidth(proxy.size.width))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewStore.timeButtonStatus.borderColor, lineWidth: 1)
                            )
                            .touchSpacer()
                            .onTapGesture {
                                viewStore.send(.selectTimeButtonTapped)
                            }
                        }

                        if let errorMessage = viewStore.errorMessage {
                            Text(errorMessage)
                                .font(.Baggle.caption3)
                                .foregroundColor(.baggleRed)
                                .padding(.horizontal, 2)
                        }
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
            .onAppear {
                viewStore.send(.onAppear)
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
                initialState: CreateDateFeature.State(),
                reducer: CreateDateFeature()
            )
        )
    }
}
