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

    let store: StoreOf<CreateDateFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 16) {

                PageIndicator(data: CreateStatus.data, selectedStatus: .date)

                Text("날짜를 정하세요")
                    .font(.largeTitle)

                GeometryReader { proxy in
                    HStack(spacing: dateButtonSpace) {

                        HStack {
                            Text(viewStore.meetingDate.koreanDate())
                            Spacer()
                        }
                        .foregroundColor(viewStore.yearMonthDateStatus.color)
                        .padding()
                        .frame(width: (proxy.size.width - dateButtonSpace) * dateWidthRatio)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(viewStore.yearMonthDateStatus.color, lineWidth: 1)
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewStore.send(.yearMonthDateButtonTapped)
                        }

                        HStack {
                            Text(viewStore.meetingDate.hourMinute())
                            Spacer()
                        }
                        .foregroundColor(viewStore.hourMinuteStatus.color)
                        .padding()
                        .frame(width: (proxy.size.width - dateButtonSpace) * (1 - dateWidthRatio))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(viewStore.hourMinuteStatus.color, lineWidth: 1)
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewStore.send(.hourMinuteButtonTapped)
                        }
                    }
                }

                Text(viewStore.description)
                    .padding()

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
                    state: \.$yearMonthDate,
                    action: { .yearMonthDate($0) })
            ) { selectDateStore in
                SelectDateView(store: selectDateStore)
                    .presentationDetents([.height(360)])
            }
            .sheet(
                store: self.store.scope(
                    state: \.$hourMinute,
                    action: { .hourMinute($0) })
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
