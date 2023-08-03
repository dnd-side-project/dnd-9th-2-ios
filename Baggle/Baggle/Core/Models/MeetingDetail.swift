//
//  MeetingDetailModel.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

/// 본인 포함 참여자 모델
struct Member: Equatable, Identifiable {
    var id: Int // 유저 id
    let name: String // 유저 이름
    let profileURL: String // 유저 프로필 이미지 URL
    let isOwner: Bool // 방장 여부
    let certified: Bool // 인증 여부
    let certImage: String // 인증 사진, 별도 분리 가능 O

    static func == (lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id
    }
}

/// 모임 상세 모델
struct MeetingDetail: Equatable {
    let id: Int // 모임 id
    let name: String // 모임 이름
    let place: String // 모임 장소
    let date: String // 모임 날짜
    let time: String // 모임 시간
    let memo: String? // 메모
    let members: [Member] // 참여자 정보
    let isConfirmed: Bool // 약속 확정 여부
    let emergencyButtonActive: Bool // 긴급 버튼 활성화 여부
    let emergencyButtonActiveTime: String? // 긴급 버튼 활성화 시간

    static func == (lhs: MeetingDetail, rhs: MeetingDetail) -> Bool {
        return lhs.id == rhs.id
    }
}
