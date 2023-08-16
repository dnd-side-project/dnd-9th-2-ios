//
//  MeetingCellView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/05.
//

import SwiftUI

struct MeetingListCell: View {

    let data: Meeting

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {

                    if data.dDay == 0 {
                        BaggleTag("D-Day", .red)
                    } else if data.dDay > 0 {
                        BaggleTag("D-\(data.dDay)")
                    }

                    HStack(spacing: 4) {
                        Text("📌")

                        Text(data.name)
                    }
                    .font(.Baggle.body1)
                    .foregroundColor(.gray11)

                    Text(
                        attributedColorString(
                            str: "장소  |  \(data.place)",
                            targetStr: "장소  |",
                            color: .gray9,
                            targetColor: .gray6
                        )
                    )
                    .font(.Baggle.description2)

                    Text(
                        attributedColorString(
                            str: "시간  |  \(data.date) \(data.time)",
                            targetStr: "시간  |",
                            color: .gray9,
                            targetColor: .gray6)
                    )
                    .font(.Baggle.description2)
                }

                HStack {
                    HStack(spacing: -4) {

                        ForEach(data.profileImages, id: \.self) { _ in
                            // 데이터 넣기
                            CircleProfileView(
                                imageUrl: "https://avatars.githubusercontent.com/u/81167570?v=4",
                                size: .extraSmall
                            )
                        }
                    }

                    Spacer()

                    Text("참여자 \(data.profileImages.count)명")
                        .font(.Baggle.description2)
                        .foregroundColor(.gray11)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)

            // 디데이 + 한시간 전인 경우와 이미 지나서 확정된 경우
            if data.isConfirmed {
                BaggleStamp(status: .confirm)
                    .padding(.bottom, 34)
                    .padding(.leading, 230)
                    .padding(.trailing, 16)
            }
        }
        .touchSpacer()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(data.status.fgColor, lineWidth: 1)
        }
    }
}

struct MeetingCellView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            MeetingListCell(
                data: Meeting(
                    id: 1,
                    name: "유탁님 없는 파티🔔",
                    place: "유탁님 없는 잠실",
                    date: "2023년 10월 23일",
                    time: "15:30",
                    dDay: 0,
                    profileImages: ["1", "2", "3", "4", "5", "6"],
                    status: .progress,
                    isConfirmed: true))

            MeetingListCell(
                data: Meeting(
                    id: 1,
                    name: "유탁님 없는 파티🔔",
                    place: "유탁님 없는 잠실",
                    date: "2023년 10월 23일",
                    time: "15:30",
                    dDay: 20,
                    profileImages: ["1", "2", "3", "4", "5", "6"],
                    status: .ready,
                    isConfirmed: false))

            MeetingListCell(
                data: Meeting(
                    id: 1,
                    name: "유탁님 없는 파티🔔",
                    place: "유탁님 없는 잠실",
                    date: "2023년 10월 23일",
                    time: "15:30",
                    dDay: -10,
                    profileImages: ["1", "2", "3", "4", "5", "6"],
                    status: .completed,
                    isConfirmed: true))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
