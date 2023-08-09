//
//  BaggleMeetingStatusTests.swift
//  BaggleTests
//
//  Created by youtak on 2023/08/09.
//

import XCTest

@testable import Baggle

final class BaggleMeetingStatusTests: XCTestCase {

    let calendar = Calendar(identifier: .gregorian)

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func createDate(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) throws -> Date {
        let targetDateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        let targetDate = calendar.date(from: targetDateComponents)
        let date = try XCTUnwrap(targetDate)

        return date
    }
    
    // MARK: - isUpcomingDays 로직 확인
    
    // meetingDate : 2023년 9월 2일 16시 05분
    // now : 2023년 8월 20일 12시 0분
    // 테스트 결과값 : true
    
    func test_meetingStatus_isUpcomingDays_01() throws {
        let meetingDate = try createDate(2023, 9, 2, 16, 05)
        let now = try createDate(2023, 8, 20, 12, 00)
        let result = meetingDate.isUpcomingDays(now)
        
        XCTAssertEqual(result, true)
    }
    
    // meetingDate : 2023년 8월 21일 15시 30분
    // now : 2023년 8월 20일 12시 0분
    // 테스트 결과값 : true

    func test_meetingStatus_isUpcomingDays_02() throws {
        let meetingDate = try createDate(2023, 8, 21, 15, 30)
        let now = try createDate(2023, 8, 20, 12, 00)
        let result = meetingDate.isUpcomingDays(now)
        
        XCTAssertEqual(result, true)
    }
  
    // meetingDate : 2023년 9월 3일 00시 05분
    // now : 2023년 9월 2일 12시 0분
    // 테스트 결과값 : true

    func test_meetingStatus_isUpcomingDays_03() throws {
        let meetingDate = try createDate(2023, 9, 3, 00, 05)
        let now = try createDate(2023, 9, 2, 12, 00)
        let result = meetingDate.isUpcomingDays(now)
        
        XCTAssertEqual(result, true)
    }

    // MARK: - Progress의 당일 확인 로직은 Swift 내부 함수를 사용함으로 Test 생략
    
    // MARK: - 약속 확정 -> 약속 시간 - 1시간 <= 지금
    
    // meetingDate : 2023년 9월 2일 18시 30분
    // now : 2023년 9월 2일 17시 30분
    // 테스트 결과값 : true
    
    func test_meetingStatus_inTheNextHour_01() throws {
        let meetingDate = try createDate(2023, 9, 2, 18, 30)
        let now = try createDate(2023, 9, 2, 17, 30)
        let result = meetingDate.inTheNextHour(now)
        
        XCTAssertEqual(result, true)
    }
    
    // meetingDate : 2023년 9월 2일 18시 30분
    // now : 2023년 9월 2일 17시 29분
    // 테스트 결과값 : false
    
    func test_meetingStatus_inTheNextHour_02() throws {
        let meetingDate = try createDate(2023, 9, 2, 18, 30)
        let now = try createDate(2023, 9, 2, 17, 29)
        let result = meetingDate.inTheNextHour(now)
        
        XCTAssertEqual(result, false)
    }

    // meetingDate : 2023년 9월 2일 18시 30분
    // now : 2023년 9월 2일 19시 30분
    // 테스트 결과값 : true
    // 시간이 지나도 약속 확정임
    
    func test_meetingStatus_inTheNextHour_03() throws {
        let meetingDate = try createDate(2023, 9, 2, 18, 30)
        let now = try createDate(2023, 9, 2, 19, 30)
        let result = meetingDate.inTheNextHour(now)
        
        XCTAssertEqual(result, true)
    }
    
    // MARK: - 다음 날로 지나감
    
    // meetingDate : 2023년 9월 2일 18시 30분
    // now : 2023년 9월 3일 0시 0분
    // 테스트 결과값 : true
    
    func test_meetingStatus_isPreviousDays_01() throws {
        let meetingDate = try createDate(2023, 9, 2, 18, 30)
        let now = try createDate(2023, 9, 3, 0, 0)
        let result = meetingDate.isPreviousDays(now)
        
        XCTAssertEqual(result, true)
    }
    
    // meetingDate : 2023년 10월 31일 19시 00분
    // now : 2023년 11월 1일 0시 0분
    // 테스트 결과값 : true

    func test_meetingStatus_isPreviousDays_02() throws {
        let meetingDate = try createDate(2023, 10, 31, 19, 00)
        let now = try createDate(2023, 11, 1, 0, 0)
        let result = meetingDate.isPreviousDays(now)
        
        XCTAssertEqual(result, true)
    }

    // meetingDate : 2023년 8월 20일 18시 30분
    // now : 2023년 8월 20일 23시 59분
    // 테스트 결과값 : false
    
    func test_meetingStatus_isPreviousDays_03() throws {
        let meetingDate = try createDate(2023, 8, 20, 18, 30)
        let now = try createDate(2023, 8, 20, 23, 59)
        let result = meetingDate.isPreviousDays(now)
        
        XCTAssertEqual(result, false)
    }

    // MARK: - Meeting Status
    
    // meetingDate : 2023년 9월 2일 16시 05분
    // now : 2023년 8월 20일 12시 0분
    // 테스트 결과값 : ready
    
//    func test_meetingStatus_reday_01() throws {
//        let meetingDate = try createDate(2023, 9, 2, 16, 05)
//        let now = try createDate(2023, 8, 20, 12, 00)
//        let result = meetingStatus(meetingDate, now)
//        
//        XCTAssertEqual(result, .ready)
//    }
//
//    // meetingDate : 2023년 9월 2일 16시 05분
//    // now : 2023년 9월 1일 23시 59분
//    // 테스트 결과값 : ready
//    
//    func test_meetingStatus_reday_02() throws {
//        let meetingDate = try createDate(2023, 9, 2, 16, 05)
//        let now = try createDate(2023, 9, 1, 23, 59)
//        let result = meetingStatus(meetingDate, now)
//        
//        XCTAssertEqual(result, .ready)
//    }
//
//    // meetingDate : 2023년 9월 2일 16시 05분
//    // now : 2023년 9월 2일 12시 00분
//    // 테스트 결과값 : progress
//    
//    func test_meetingStatus_progress_01() throws {
//        let meetingDate = try createDate(2023, 9, 2, 16, 05)
//        let now = try createDate(2023, 9, 2, 12, 00)
//        let result = meetingStatus(meetingDate, now)
//
//        XCTAssertEqual(result, .progress)
//    }
//
//    // meetingDate : 2023년 9월 2일 16시 00분
//    // now : 2023년 9월 2일 14시 59분
//    // 테스트 결과값 : progress
//    
//    func test_meetingStatus_progress_02() throws {
//        let meetingDate = try createDate(2023, 9, 2, 16, 00)
//        let now = try createDate(2023, 9, 2, 14, 59)
//        let result = meetingStatus(meetingDate, now)
//        
//        XCTAssertEqual(result, .progress)
//    }
//    
//    // meetingDate : 2023년 9월 2일 16시 00분
//    // now : 2023년 9월 2일 15시 00분
//    // 테스트 결과값 : confirmed
//    
//    func test_meetingStatus_confirmed_01() throws {
//        let meetingDate = try createDate(2023, 9, 2, 16, 00)
//        let now = try createDate(2023, 9, 2, 15, 00)
//        let result = meetingStatus(meetingDate, now)
//
//        XCTAssertEqual(result, .confirmed)
//    }
//
//    // meetingDate : 2023년 9월 2일 16시 00분
//    // now : 2023년 9월 2일 17시 00분
//    // 테스트 결과값 : confirmed
//    
//    func test_meetingStatus_confirmed_02() throws {
//        let meetingDate = try createDate(2023, 9, 2, 16, 00)
//        let now = try createDate(2023, 9, 2, 17, 00)
//        let result = meetingStatus(meetingDate, now)
//
//        XCTAssertEqual(result, .confirmed)
//    }
//
//    // meetingDate : 2023년 9월 2일 16시 00분
//    // now : 2023년 9월 3일 00시 00분
//    // 테스트 결과값 : completed
//    
//    func test_meetingStatus_completed_01() throws {
//        let meetingDate = try createDate(2023, 9, 2, 16, 00)
//        let now = try createDate(2023, 9, 3, 00, 00)
//        let result = meetingStatus(meetingDate, now)
//
//        XCTAssertEqual(result, .completed)
//    }
//
//    // meetingDate : 2023년 9월 2일 23시 59분
//    // now : 2023년 9월 3일 00시 00분
//    // 테스트 결과값 : completed
//    
//    func test_meetingStatus_completed_02() throws {
//        let meetingDate = try createDate(2023, 9, 2, 23, 59)
//        let now = try createDate(2023, 9, 3, 00, 00)
//        let result = meetingStatus(meetingDate, now)
//
//        XCTAssertEqual(result, .completed)
//    }
}
