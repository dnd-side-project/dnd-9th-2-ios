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
    let status: String
    let certificationTime: Date?
    let members: [MeetingDetailMemberEntity]

    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case title, place, meetingTime, memo, status, certificationTime, members
    }
}

extension MeetingDetailEntity {
    func toDomain(username: String) -> MeetingDetail {
        MeetingDetail(
            id: self.meetingID,
            name: self.title,
            place: self.place,
            date: self.meetingTime.koreanDate(),
            time: self.meetingTime.hourMinute(),
            memo: self.memo,
            members: self.members.map { $0.memberDomain(meetingConfirmed: isMeetingConfirmed()) },
            memberId: memberId(username: username, members: members),
            status: meetingStatus(),
            isEmergencyAuthority: isEmergencyAuthority(username: username, members: self.members),
            emergencyButtonActive: self.certificationTime != nil,
            emergencyButtonActiveTime: self.certificationTime,
            emergencyButtonExpiredTime: emergencyButtonExpiredTime(meetingTime: self.meetingTime),
            isCertified: isCertified(username: username, members: self.members),
            feeds: self.members.compactMap { $0.feedDomain() }
        )
    }

    private func meetingStatus() -> MeetingStatus {
        switch status {
        case "SCHEDULED": return .ready
        case "ONGOING": return .progress
        case "CONFIRMATION": return .confirmed
        case "TERMINATION": return .completed
        default: return meetingStatus(date: self.meetingTime)
        }
    }
    
    private func meetingStatus(date: Date) -> MeetingStatus {
        
        // 약속 전날
        if date.isUpcomingDays {
            return .ready
        }

        // 약속 날 지났을 때
        if date.isPreviousDays {
            return .completed
        }

        // 약속 당일 1 시간 전
        if date.inTheNextHour {
            return .confirmed
        }
        
        // 약속 당일
        return .progress
    }
    
    // 서버에서 멤버가 새로 들어올 때마다 랜덤으로 권한자가 설정됨
    // 모임 확정 시간 전까지 버튼 권한자를 보여주면 안 됨
    private func isMeetingConfirmed() -> Bool {
        return meetingStatus(date: self.meetingTime) == .confirmed
    }
    
    private func memberId(username: String, members: [MeetingDetailMemberEntity]) -> Int {
        return members.filter({ $0.nickname == username }).first?.memberID ?? -1
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
}
