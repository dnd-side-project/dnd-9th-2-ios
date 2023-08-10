//
//  MeetingDetailModel.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

/// 모임 상세 모델
struct MeetingDetail: Equatable {
    let id: Int // 모임 id
    let name: String // 모임 이름
    let place: String // 모임 장소
    let date: String // 모임 날짜
    let time: String // 모임 시간
    let memo: String? // 메모
    let members: [Member] // 참여자 정보
    let status: MeetingStatus // 약속 상태
    let isEmergencyAuthority: Bool // 긴급 버튼 권한자
    let emergencyButtonActive: Bool // 긴급 버튼 활성화 여부
    let emergencyButtonActiveTime: Date? // 긴급 버튼 활성화 시간
    let isCertified: Bool
    let feeds: [Feed]

    static func == (lhs: MeetingDetail, rhs: MeetingDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

/// 본인 포함 참여자 모델
struct Member: Identifiable, Hashable {
    var id: Int // 유저 id
    let name: String // 유저 이름
    let profileURL: String // 유저 프로필 이미지 URL
    let isMeetingAuthority: Bool // 방장 여부
    let isButtonAuthority: Bool // 긴급 버튼 할당자 여부
    let certified: Bool // 인증 여부
    let certImage: String // 인증 사진, 별도 분리 가능 O

    static func == (lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id
    }
}

/// 모임 인증 피드
struct Feed {
    let id: Int
    let userId: Int
    let username: String
    let userImageURL: String
    let feedImageURL: String
}
