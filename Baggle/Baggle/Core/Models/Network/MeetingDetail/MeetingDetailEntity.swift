//
//  MeetingDetailEntity.swift
//  Baggle
//
//  Created by youtak on 2023/08/09.
//

import Foundation

struct MeetingDetailEntity: Codable {
    let meetingID: Int
    let title: String
    let place: String
    let meetingTime: Date
    let memo: String?
    let certificationTime: Date?
    let status: MeetingStatusEntity
    let members: [MeetingDetailMemberEntity]

    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case title, place, meetingTime, memo, status, certificationTime, members
    }
}

extension MeetingDetailEntity {
    func toDomain(username: String) -> MeetingDetail {
        MeetingDetail(
            id: meetingID,
            name: title.lineChanged(),
            place: place,
            date: meetingTime.koreanDate(),
            time: meetingTime.hourMinute(),
            memo: (memo ?? "").isEmpty ? nil : memo,
            members: members.map { $0.memberDomain(afterMeetingConfirmed: isMeetingConfirmed()) },
            memberID: memberId(username: username, members: members),
            isOwner: isOwner(username: username, members: members),
            stampStatus: status.meetingStampStatus(),
            emergencyStatus: status.meetingEmergencyStatus(),
            isEmergencyAuthority: isEmergencyAuthority(username: username, members: self.members),
            emergencyButtonActive: self.certificationTime != nil,
            emergencyButtonActiveTime: self.certificationTime,
            emergencyButtonExpiredTime: emergencyButtonExpiredTime(meetingTime: self.meetingTime),
            isCertified: isCertified(username: username, members: self.members),
            feeds: feeds()
        )
    }

    
    // 서버에서 멤버가 새로 들어올 때마다 랜덤으로 권한자가 설정됨
    // 모임 확정 시간 전까지 버튼 권한자를 보여주면 안 됨
    private func isMeetingConfirmed() -> Bool {
        return status != .scheduled
    }
    
    private func memberId(username: String, members: [MeetingDetailMemberEntity]) -> Int {
        return members.filter({ $0.nickname == username }).first?.memberID ?? -1
    }

    private func isOwner(username: String, members: [MeetingDetailMemberEntity]) -> Bool {
        return members.contains { $0.nickname == username && $0.meetingAuthority }
    }
    
    private func isEmergencyAuthority(
        username: String,
        members: [MeetingDetailMemberEntity]
    ) -> Bool {
        return members.contains { $0.nickname == username && $0.buttonAuthority }
    }
    
    private func isCertified(username: String, members: [MeetingDetailMemberEntity]) -> Bool {
        return members.contains { $0.nickname == username && $0.feedID != nil }
    }

    private func emergencyButtonExpiredTime(meetingTime: Date) -> Date {
        return self.meetingTime.emergencyTimeOut()
    }

    private func feeds() -> [Feed] {
        self.members.compactMap { $0.feedDomain() }.sorted { $0.id > $1.id }
    }
}
