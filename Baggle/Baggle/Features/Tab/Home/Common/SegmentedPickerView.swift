//
//  SegmentedPickerView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/04.
//

import SwiftUI

struct Segment: Identifiable {
    var id: MeetingStatus
    let count: Int
    let isSelected: Bool
    let action: () -> Void
}

struct SegmentedPickerView: View {
    let segment: [Segment]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segment) { info in
                SegmentedTagView(
                    title: info.id.segmentTitle,
                    count: info.count,
                    isSelected: info.isSelected
                )
                .onTapGesture {
                    info.action()
                }
            }

            Spacer()
        }
    }
}

struct SegmentedPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedPickerView(segment: [
            Segment(
                id: .ready,
                count: 10,
                isSelected: true,
                action: { print("예정된 약속") }),
            Segment(
                id: .completed,
                count: 1,
                isSelected: false,
                action: { print("지난 약속") })
        ])
    }
}
