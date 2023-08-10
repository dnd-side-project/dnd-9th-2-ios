//
//  TestDateService.swift
//  BaggleTests
//
//  Created by youtak on 2023/08/10.
//

import XCTest

@testable import Baggle

struct TestDateService {
    
    let calendar = Calendar(identifier: .gregorian)
    
    // MARK: - 특정 날짜 생성
    
    func createDate(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) throws -> Date {
        let targetDateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        let targetDate = calendar.date(from: targetDateComponents)
        let date = try XCTUnwrap(targetDate)

        return date
    }
    
    // MARK: - 목업 Meeting Status 생성
    // 특정 시간(meetingTime)을 인자로 받아 Meeting Status 생성
    
    func meetingDetailStatus(meetingTime: Date) -> MeetingStatus {
        let entity = MeetingDetailEntity(
            meetingID: 0,
            title: "Test용",
            place: "강남역 456번 출구",
            meetingTime: meetingTime,
            memo: "메모메모",
            certificationTime: nil,
            members: []
        )
        
        let meetingDetail = entity.toDomain(userID: User.mockUp().id)
        
        return meetingDetail.status
    }

    func isSameDay(_ date1 : Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}
