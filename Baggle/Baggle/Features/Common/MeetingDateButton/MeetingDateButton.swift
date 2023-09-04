//
//  MeetingDateButton.swift
//  Baggle
//
//  Created by youtak on 2023/08/31.
//

import SwiftUI

import ComposableArchitecture

struct MeetingDateButton: View {
    
    private let dateButtonSpace: CGFloat = 10
    private let dateWidthRatio = 0.65
    private let dateButtonHeight: CGFloat = 54
    
    let store: StoreOf<MeetingDateButtonFeature>
    @Binding var meetingDate: Date
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            GeometryReader { proxy in
                
                HStack(spacing: dateButtonSpace) {
                    
                    // MARK: - Date Button

                    HStack {
                        Text(meetingDate.koreanDate())
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
                        Text(meetingDate.hourMinute())
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
            }
            .frame(height: dateButtonHeight)
        }
    }
}

extension MeetingDateButton {
    private func dateWidth(_ containerWidth: CGFloat) -> CGFloat {
        abs(containerWidth - dateButtonSpace) * dateWidthRatio
    }
    
    private func timerWidth(_ containerWidth: CGFloat) -> CGFloat {
        abs(containerWidth - dateButtonSpace) * (1 - dateWidthRatio)
    }
}


struct MeetingDateButton_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDateButton(
            store: Store(
                initialState: MeetingDateButtonFeature.State(),
                reducer: MeetingDateButtonFeature()
            ),
            meetingDate: .constant(Date())
        )
    }
}
