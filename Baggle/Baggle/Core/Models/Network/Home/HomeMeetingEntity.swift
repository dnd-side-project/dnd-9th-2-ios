//
//  HomeMeetingEntity.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

struct HomeMeetingEntity: Codable {
    let meetingID: Int
    let remainingDate: Int
    let title: String
    let place: String
    let time: Date
    let participantCount: Int
    let status: String // 'SCHEDULED', 'CONFIRMATION', 'ONGOING', 'TERMINATION’
    let participants: [String]
    
    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case remainingDate, title, place, time, participantCount, status, participants
    }
}

extension HomeMeetingEntity {
    func toDomain() -> Meeting {
        return Meeting(
            id: meetingID,
            name: title,
            place: place,
            date: time.koreanDate(),
            time: time.hourMinute(),
            dDay: remainingDate,
            profileImages: participants,
            status: meetingStatus())
    }
    
    private func meetingStatus() -> MeetingStatus {
        switch status {
        case "SCHEDULED": return .ready
        case "ONGOING": return .progress
        case "CONFIRMATION": return .confirmed
        case "TERMINATION": return .completed
        default: return meetingStatusWithDate()
        }
    }
    
    private func meetingStatusWithDate() -> MeetingStatus {
        
        // 약속 전날
        if time.isUpcomingDays {
            return .ready
        }
        
        // 약속 날 지났을 때
        if time.isPreviousDays {
            return .completed
        }
        
        // 약속 당일 1시간 전
        if time.inTheNextHour {
            return .confirmed
        }
        
        // 약속 당일
        return .progress
    }
}
