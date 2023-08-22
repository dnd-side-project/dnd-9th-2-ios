//
//  BaggleMeetingStatusTests.swift
//  BaggleTests
//
//  Created by youtak on 2023/08/09.
//

import XCTest

@testable import Baggle

final class BaggleMeetingStatusTests: XCTestCase {

    let testDateService = TestDateService()

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    // MARK: - isUpcomingDays 로직 확인
    
    // meetingDate : 2023년 9월 2일 16시 05분
    // now : 2023년 8월 20일 12시 0분
    // 테스트 결과값 : true
    
    func test_meetingStatus_isUpcomingDays_01() throws {
        let meetingDate = try testDateService.createDate(2023, 9, 2, 16, 05)
        let now = try testDateService.createDate(2023, 8, 20, 12, 00)
        let result = meetingDate.isUpcomingDays(now)
        
        XCTAssertEqual(result, true)
    }
    
    // meetingDate : 2023년 8월 21일 15시 30분
    // now : 2023년 8월 20일 12시 0분
    // 테스트 결과값 : true

    func test_meetingStatus_isUpcomingDays_02() throws {
        let meetingDate = try testDateService.createDate(2023, 8, 21, 15, 30)
        let now = try testDateService.createDate(2023, 8, 20, 12, 00)
        let result = meetingDate.isUpcomingDays(now)
        
        XCTAssertEqual(result, true)
    }
  
    // meetingDate : 2023년 9월 3일 00시 05분
    // now : 2023년 9월 2일 12시 0분
    // 테스트 결과값 : true

    func test_meetingStatus_isUpcomingDays_03() throws {
        let meetingDate = try testDateService.createDate(2023, 9, 3, 00, 05)
        let now = try testDateService.createDate(2023, 9, 2, 12, 00)
        let result = meetingDate.isUpcomingDays(now)
        
        XCTAssertEqual(result, true)
    }

    // MARK: - Progress의 당일 확인 로직은 Swift 내부 함수를 사용함으로 Test 생략
    
    // MARK: - 약속 확정 -> 약속 시간 - 1시간 <= 지금
    
    // meetingDate : 2023년 9월 2일 18시 30분
    // now : 2023년 9월 2일 17시 30분
    // 테스트 결과값 : true
    
    func test_meetingStatus_inTheNextHour_01() throws {
        let meetingDate = try testDateService.createDate(2023, 9, 2, 18, 30)
        let now = try testDateService.createDate(2023, 9, 2, 17, 30)
        let result = meetingDate.inTheNextHour(now)
        
        XCTAssertEqual(result, true)
    }
    
    // meetingDate : 2023년 9월 2일 18시 30분
    // now : 2023년 9월 2일 17시 29분
    // 테스트 결과값 : false
    
    func test_meetingStatus_inTheNextHour_02() throws {
        let meetingDate = try testDateService.createDate(2023, 9, 2, 18, 30)
        let now = try testDateService.createDate(2023, 9, 2, 17, 29)
        let result = meetingDate.inTheNextHour(now)
        
        XCTAssertEqual(result, false)
    }

    // meetingDate : 2023년 9월 2일 18시 30분
    // now : 2023년 9월 2일 19시 30분
    // 테스트 결과값 : true
    // 시간이 지나도 약속 확정임
    
    func test_meetingStatus_inTheNextHour_03() throws {
        let meetingDate = try testDateService.createDate(2023, 9, 2, 18, 30)
        let now = try testDateService.createDate(2023, 9, 2, 19, 30)
        let result = meetingDate.inTheNextHour(now)
        
        XCTAssertEqual(result, true)
    }
    
    // MARK: - 다음 날로 지나감
    
    // meetingDate : 2023년 9월 2일 18시 30분
    // now : 2023년 9월 3일 0시 0분
    // 테스트 결과값 : true
    
    func test_meetingStatus_isPreviousDays_01() throws {
        let meetingDate = try testDateService.createDate(2023, 9, 2, 18, 30)
        let now = try testDateService.createDate(2023, 9, 3, 0, 0)
        let result = meetingDate.isPreviousDays(now)
        
        XCTAssertEqual(result, true)
    }
    
    // meetingDate : 2023년 10월 31일 19시 00분
    // now : 2023년 11월 1일 0시 0분
    // 테스트 결과값 : true

    func test_meetingStatus_isPreviousDays_02() throws {
        let meetingDate = try testDateService.createDate(2023, 10, 31, 19, 00)
        let now = try testDateService.createDate(2023, 11, 1, 0, 0)
        let result = meetingDate.isPreviousDays(now)
        
        XCTAssertEqual(result, true)
    }

    // meetingDate : 2023년 8월 20일 18시 30분
    // now : 2023년 8월 20일 23시 59분
    // 테스트 결과값 : false
    
    func test_meetingStatus_isPreviousDays_03() throws {
        let meetingDate = try testDateService.createDate(2023, 8, 20, 18, 30)
        let now = try testDateService.createDate(2023, 8, 20, 23, 59)
        let result = meetingDate.isPreviousDays(now)
        
        XCTAssertEqual(result, false)
    }

    // MARK: - Meeting Status
    
    // now : 테스트 시간
    // meetingDate : now + 1시간 30분
    // 테스트 결과값 : progress, ready
    
    func test_meetingStatus_01() throws {
        let now = Date()
        let meetingTime = now.later(hours: 1).later(minutes: 30)
        let result = testDateService.meetingDetailStatus(meetingTime: meetingTime)

        if testDateService.isSameDay(now, meetingTime) {
            // 1시간 30분이 지났어도 같은 날
            XCTAssertEqual(result, .termination)
        } else {
            // 1시간 30분이 지났는데 다른 날
            // now : 23시, meetingTime : 0시 30분
            XCTAssertEqual(result, .past)
        }
    }

    // now : 테스트 시간
    // meetingDate : now + 60분
    // 테스트 결과값 : confirmed
    
    func test_meetingStatus_02() throws {
        let now = Date()
        let meetingTime = now.later(minutes: 60)
        let result = testDateService.meetingDetailStatus(meetingTime: meetingTime)

        XCTAssertEqual(result, .confirmation)
    }

    // now : 테스트 시간
    // meetingDate : now - 2시간
    // 테스트 결과값 : confirmed, completed
    
    func test_meetingStatus_03() throws {
        let now = Date()
        let meetingTime = now.before(hours: 2)
        let result = testDateService.meetingDetailStatus(meetingTime: meetingTime)

        if testDateService.isSameDay(now, meetingTime) {
            // 날이 안 지남
            // now : 22시
            // meetingDate: 20시
            XCTAssertEqual(result, .confirmation)
        } else {
            // 약속 다음 날로 넘어감
            // now : 01시
            // meetingDate: 23시
            XCTAssertEqual(result, .termination)
        }
    }

    // now : 테스트 시간
    // meetingDate : now + 24시간
    // 테스트 결과값 : ready
    
    func test_meetingStatus_04() throws {
        let now = Date()
        let meetingTime = now.later(hours: 24)
        let result = testDateService.meetingDetailStatus(meetingTime: meetingTime)

        XCTAssertEqual(result, .scheduled)
    }

    // now : 테스트 시간
    // meetingDate : now - 24시간
    // 테스트 결과값 : ready
    
    func test_meetingStatus_05() throws {
        let now = Date()
        let meetingTime = now.before(hours: 24)
        let result = testDateService.meetingDetailStatus(meetingTime: meetingTime)

        XCTAssertEqual(result, .termination)
    }
}
