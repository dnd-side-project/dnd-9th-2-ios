//
//  Memeber.swift
//  Baggle
//
//  Created by youtak on 2023/08/10.
//

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
