//
//  MeetingModel.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

/// 서버에서 받은 Entity를 View에 바로 적용가능하도록 가공한 Model
/// - 모임까지 남은 날짜(D-Day), 모임 이름, 장소, 시간, 참여자 프로필 이미지, 참여자 수, 약속 확정 여부

struct MeetingListModel {
    let meetings: [MeetingModel]
}

struct MeetingModel: Equatable {
    let id: Int
    let name: String
    let place: String
    let date: String
    let time: String
    let profileImages: [String]
    let isConfirmed: Bool

    static func == (lhs: MeetingModel, rhs: MeetingModel) -> Bool {
        return lhs.id == rhs.id
    }
}
