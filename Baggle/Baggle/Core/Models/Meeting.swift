//
//  MeetingModel.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

/// 서버에서 받은 Entity를 View에 바로 적용가능하도록 가공한 Model
struct Meeting: Equatable, Identifiable {
    let id: Int // 모임 id
    let name: String // 모임 이름
    let place: String // 장소
    let date: String // 날짜
    let time: String // 시간
    let dDay: Int
    let profileImages: [String] // 프로필 이미지
    let status: MeetingStatus
    let isConfirmed: Bool // 약속 확정 여부

    static func == (lhs: Meeting, rhs: Meeting) -> Bool {
        return lhs.id == rhs.id
    }
}
