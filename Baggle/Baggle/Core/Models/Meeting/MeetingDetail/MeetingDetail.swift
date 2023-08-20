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
    let memberId: Int // 모임 내 본인의 멤버id
    let status: MeetingStatus // 약속 상태
    let isEmergencyAuthority: Bool // 긴급 버튼 권한자
    let emergencyButtonActive: Bool // 긴급 버튼 활성화 여부
    let emergencyButtonActiveTime: Date? // 긴급 버튼 활성화 시간
    let emergencyButtonExpiredTime: Date // 긴급 버튼 만료 시간 - 모임 10분 전
    let isCertified: Bool
    let feeds: [Feed]

    static func == (lhs: MeetingDetail, rhs: MeetingDetail) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MeetingDetail {
    func updateFeed(_ feed: Feed) -> MeetingDetail {
        MeetingDetail(
            id: self.id,
            name: self.name,
            place: self.place,
            date: self.date,
            time: self.time,
            memo: self.memo,
            members: self.members,
            memberId: self.memberId,
            status: self.status,
            isEmergencyAuthority: self.isEmergencyAuthority,
            emergencyButtonActive: self.emergencyButtonActive,
            emergencyButtonActiveTime: self.emergencyButtonActiveTime,
            emergencyButtonExpiredTime: self.emergencyButtonExpiredTime,
            isCertified: true,
            feeds: self.feeds + [feed]
        )
    }
}
