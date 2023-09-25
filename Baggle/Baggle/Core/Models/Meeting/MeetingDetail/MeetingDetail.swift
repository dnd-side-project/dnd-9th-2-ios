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
    let memberID: Int // 모임 내 본인의 멤버id
    let isOwner: Bool // 모임 내 방장여부
    let stampStatus: MeetingStampStatus // 제목 옆에 들어가는 약속 도장
    let emergencyStatus: MeetingEmergencyStatus // 긴급 버튼 상태
    let isEmergencyAuthority: Bool // 내가 긴급 버튼 권한자
    let emergencyButtonActive: Bool // 긴급 버튼 활성화 여부
    let emergencyButtonActiveTime: Date? // 긴급 버튼 활성화 시간
    let emergencyButtonExpiredTime: Date // 긴급 버튼 만료 시간 - 모임 15분 전
    let isCertified: Bool
    let feeds: [Feed]
}

extension MeetingDetail {
    
    // 긴급 버튼 활성화
    // emergencyStatus -> .ongoing으로 변경
    
    func updateEmergemcy(_ emergencyActiveTime: Date) -> MeetingDetail {
        MeetingDetail(
            id: id,
            name: name,
            place: place,
            date: date,
            time: date,
            memo: memo,
            members: members,
            memberID: memberID,
            isOwner: isOwner,
            stampStatus: stampStatus,
            emergencyStatus: .onGoing,
            isEmergencyAuthority: isEmergencyAuthority,
            emergencyButtonActive: true,
            emergencyButtonActiveTime: emergencyActiveTime,
            emergencyButtonExpiredTime: emergencyButtonExpiredTime,
            isCertified: isCertified,
            feeds: feeds
        )
    }
    

    // 긴급 종료 이후 피드 업데이트
    // emergencyStatus -> .terminattion으로 변경
    
    func updateFeed(_ feed: Feed) -> MeetingDetail {
        let updatedMembers = self.members.map {
            return $0.id == self.memberID ? $0.updateFeed(certImage: feed.feedImageURL) : $0
        }
        
        return MeetingDetail(
            id: self.id,
            name: self.name,
            place: self.place,
            date: self.date,
            time: self.time,
            memo: self.memo,
            members: updatedMembers,
            memberID: self.memberID,
            isOwner: self.isOwner,
            stampStatus: self.stampStatus,
            emergencyStatus: self.emergencyStatus,
            isEmergencyAuthority: self.isEmergencyAuthority,
            emergencyButtonActive: self.emergencyButtonActive,
            emergencyButtonActiveTime: self.emergencyButtonActiveTime,
            emergencyButtonExpiredTime: self.emergencyButtonExpiredTime,
            isCertified: true,
            feeds: self.feeds + [feed]
        )
    }

    func afterEmergencyAuthority() -> Bool {
        return emergencyStatus == .past || emergencyStatus == .termination
    }

    // 모임 수정 이후 업데이트
    func updateMeetingEdit(_ meetingEditSuccessModel: MeetingEditSuccessModel) -> MeetingDetail {
        MeetingDetail(
            id: meetingEditSuccessModel.meetingID,
            name: meetingEditSuccessModel.title,
            place: meetingEditSuccessModel.place,
            date: meetingEditSuccessModel.meetingTime.koreanDate(),
            time: meetingEditSuccessModel.meetingTime.hourMinute(),
            memo: meetingEditSuccessModel.memo,
            members: self.members,
            memberID: self.memberID,
            isOwner: self.isOwner,
            stampStatus: self.stampStatus,
            emergencyStatus: self.emergencyStatus,
            isEmergencyAuthority: self.isEmergencyAuthority,
            emergencyButtonActive: self.emergencyButtonActive,
            emergencyButtonActiveTime: self.emergencyButtonActiveTime,
            emergencyButtonExpiredTime: self.emergencyButtonExpiredTime,
            isCertified: self.isCertified,
            feeds: self.feeds
        )
    }
    
    
    // 신고 이후 업데이트
    func updateReport(reportFeedID: Int) -> MeetingDetail? {
        
        guard let reportMemberID = self.feeds.filter({ $0.id == reportFeedID }).first?.userID else {
            return nil
        }
        
        return MeetingDetail(
            id: self.id,
            name: self.name,
            place: self.place,
            date: self.date,
            time: self.time,
            memo: self.memo,
            members: self.members.map { $0.updateAfterReport(reportMemberID: reportMemberID) },
            memberID: self.memberID,
            isOwner: self.isOwner,
            stampStatus: self.stampStatus,
            emergencyStatus: self.emergencyStatus,
            isEmergencyAuthority: self.isEmergencyAuthority,
            emergencyButtonActive: self.emergencyButtonActive,
            emergencyButtonActiveTime: self.emergencyButtonActiveTime,
            emergencyButtonExpiredTime: self.emergencyButtonExpiredTime,
            isCertified: self.isCertified,
            feeds: self.feeds.map { $0.updateAfterReport(reportFeedID: reportFeedID) }
        )
    }
}

// 모임 수정을 위한 Meeting Edit로 변환

extension MeetingDetail {
    func toMeetingEdit() -> MeetingEditModel? {
        guard let date = self.meetingDate() else {
            return nil
        }
        return MeetingEditModel(
            id: self.id,
            title: self.name,
            place: self.place,
            date: date,
            memo: self.memo ?? ""
        )
    }
    
    private func meetingDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일HH:mm"
        let dateString = self.date + self.time
        return dateFormatter.date(from: dateString)
    }
}
