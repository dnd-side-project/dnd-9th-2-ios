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

                    if let dday = data.dday {
                        if dday == 0 {
                            BaggleTag("D-Day", .pink)
                        } else {
                            BaggleTag("D-\(dday)")
                        }
                    }

                    HStack(spacing: 4) {
                        Text("📌")

                        Text(data.name)
                    }

                    Text(attributedColorString(str: "장소  |  \(data.place)",
                                               targetStr: "장소  |",
                                               color: .black,
                                               targetColor: .gray))
                    .font(.system(size: 14))

                    Text(attributedColorString(str: "시간  |  \(data.date) \(data.time)",
                                               targetStr: "시간  |",
                                               color: .black,
                                               targetColor: .gray))
                    .font(.system(size: 14))
                }

                HStack {
                    HStack(spacing: -4) {

                        ForEach(data.profileImages, id: \.self) { _ in
                            // 데이터 넣기
                            CircleProfileView(
                                imageUrl: "https://avatars.githubusercontent.com/u/81167570?v=4",
                                size: .extraSmall)
                        }
                    }

                    Spacer()

                    Text("참여자 \(data.profileImages.count)명")
                        .font(.system(size: 14))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)

            // 디데이 + 한시간 전인 경우와 이미 지나서 확정된 경우
            if data.isConfirmed {
                // 스탬프로 이미지 변경
                Image(systemName: "moon")
                    .frame(width: 121, height: 89)
                    .background(.black.opacity(0.4))
                    .padding(.bottom, 12)
                    .padding(.trailing, 12)
            }
        }
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
                    dday: 0,
                    profileImages: ["1", "2", "3", "4", "5", "6"],
                    status: .dday,
                    isConfirmed: true))

            MeetingListCell(
                data: Meeting(
                    id: 1,
                    name: "유탁님 없는 파티🔔",
                    place: "유탁님 없는 잠실",
                    date: "2023년 10월 23일",
                    time: "15:30",
                    dday: 20,
                    profileImages: ["1", "2", "3", "4", "5", "6"],
                    status: .ongoing,
                    isConfirmed: false))

            MeetingListCell(
                data: Meeting(
                    id: 1,
                    name: "유탁님 없는 파티🔔",
                    place: "유탁님 없는 잠실",
                    date: "2023년 10월 23일",
                    time: "15:30",
                    dday: nil,
                    profileImages: ["1", "2", "3", "4", "5", "6"],
                    status: .complete,
                    isConfirmed: true))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
