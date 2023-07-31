//
//  MeetingDetailModel.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

/// - 모임 이름, 장소, 시간, 메모
/// - 약속 진행 여부(예정된 약속/지난 약속 또는 확정 여부),
/// - 참여자 목록 (닉네임, 프로필 이미지, 방장 여부, 긴급 버튼 할당자 여부, 인증 여부) -> 따로
/// - 인증 피드 (참여자, 이미지)
/// - 긴급 버튼 발동 여부, 긴급 버튼 발동 시간
/// - 본인 사진 인증 여부

/// 본인 포함 참여자 모델
struct MemberModel {
    let userid: Int
    let name: String
    let profile: String
    let owner: Bool
    let certefied: Bool
}

struct MeetingDetailModel: Equatable {
    let id: Int
    let name: String
    let place: String
    let date: String
    let time: String
    let memo: String?
    let isConfirmed: Bool // 약속 확정 여부
    let emergencyButtonActive: Bool
    let emergencyButtonActiveTime: String
    // 본인 인증, 방장 여부 추가 가능

    static func == (lhs: MeetingDetailModel, rhs: MeetingDetailModel) -> Bool {
        return lhs.id == rhs.id
    }
}
