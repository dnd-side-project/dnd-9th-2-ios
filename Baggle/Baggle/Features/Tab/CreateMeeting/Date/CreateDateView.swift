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

    @State var pickerDate = Date()

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 16) {

                PageIndicator(data: CreateStatus.data, selectedStatus: .date)

                Text("날짜를 정하세요")
                    .font(.largeTitle)

                GeometryReader { proxy in
                    HStack(spacing: dateButtonSpace) {

                        HStack {
                            Text("2023년 7월 23일")
                            Spacer()
                        }
                        .padding()
                        .frame(width: (proxy.size.width - dateButtonSpace) * dateWidthRatio)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1)
                        )
                        .onTapGesture {
                            viewStore.send(.yearMonthDateButtonTapped)
                        }

                        HStack {
                            Text("21:30")
                            Spacer()
                        }
                        .padding()
                        .frame(width: (proxy.size.width - dateButtonSpace) * (1 - dateWidthRatio))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1)
                        )
                    }
                }

                Spacer()

                Button {
                    viewStore.send(.nextButtonTapped)
                } label: {
                    Text("다음")
                }
                .buttonStyle(BagglePrimaryStyle())
            }
            .padding()
            .sheet(
                store: self.store.scope(
                    state: \.$yearMonthDate,
                    action: { .yearMonthDate($0) })
            ) { yearMonthDateStore in
                YearMonthDateView(store: yearMonthDateStore)
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
