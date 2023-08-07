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
                            .padding(.horizontal, 2)

                        HStack(spacing: dateButtonSpace) {

                            HStack {
                                Text(viewStore.meetingDate.koreanDate())
                                Spacer()
                            }
                            .foregroundColor(viewStore.dateButtonStatus.foregroundColor)
                            .padding()
                            .frame(
                                width: abs(proxy.size.width - dateButtonSpace) * dateWidthRatio
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewStore.dateButtonStatus.borderColor, lineWidth: 1)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewStore.send(.selectDateButtonTapped)
                            }

                            HStack {
                                Text(viewStore.meetingDate.hourMinute())
                                Spacer()
                            }
                            .foregroundColor(viewStore.timeButtonStatus.foregroundColor)
                            .padding()
                            .frame(
                                width: abs(proxy.size.width - dateButtonSpace) * (1 - dateWidthRatio)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewStore.timeButtonStatus.borderColor, lineWidth: 1)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewStore.send(.selectTimeButtonTapped)
                            }
                        }

                        if let errorMessage = viewStore.errorMessage {
                            Text(errorMessage)
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

struct CreateMeetingDateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDateView(
            store: Store(
                initialState: CreateDateFeature.State(),
                reducer: CreateDateFeature()
            )
        )
    }
}
