//
//  BaggleTests.swift
//  BaggleTests
//
//  Created by youtak on 2023/08/01.
//

import XCTest

@testable import Baggle

final class BaggleDateTests: XCTestCase {

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

    // MARK: - 한글 출력
    // 화면에 보일 한글 날짜

    // 시각 : 2023년 09월 01일 12시 30분
    // 결과 : "2023년 9월 1일"
    func test_한글출력_날짜_01() throws {
        let date = try createDate(2023, 9, 1, 12, 30)
        let result = date.koreanDate()

        XCTAssertEqual(result, "2023년 9월 1일")
    }

    // 시각 : 2023년 09월 01일 12시 30분
    // 결과 : "12:30"
    func test_한글출력_시간_01() throws {
        let date = try createDate(2023, 9, 1, 12, 30)
        let result = date.hourMinute()

        XCTAssertEqual(result, "12:30")
    }

    // 시각 : 2023년 8월 5일 18시 51분
    // 약속 생성 가능 시각 : 2023년 8월 5일 20시 55분
    // 테스트 결과값 : "2023년 8월 5일"
    func test_약속가능시간_생성_날짜_01() throws {
        let date = try createDate(2023, 8, 5, 18, 51)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.koreanDate()

        XCTAssertEqual(result, "2023년 8월 5일")
    }

    // 시각 : 2023년 8월 5일 18시 51분
    // 약속 생성 가능 시각 : 2023년 8월 5일 20시 55분
    // 테스트 결과값 : "20:55"
    func test_약속가능시간_생성_시간_01() throws {
        let date = try createDate(2023, 8, 5, 18, 51)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.hourMinute()

        XCTAssertEqual(result, "20:55")
    }

    // 시각 : 2023년 8월 20일 22시 33분
    // 약속 생성 가능 시각 : 2023년 8월 21일 00시 35분
    // 테스트 결과값 : "2023년 8월 21일"
    func test_약속가능시간_생성_날짜_02() throws {
        let date = try createDate(2023, 8, 20, 22, 33)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.koreanDate()

        XCTAssertEqual(result, "2023년 8월 21일")
    }

    // 시각 : 2023년 8월 20일 22시 33분
    // 약속 생성 가능 시각 : 2023년 8월 21일 00시 35분
    // 테스트 결과값 : "00:35"
    func test_약속가능시간_생성_시간_02() throws {
        let date = try createDate(2023, 8, 20, 22, 33)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.hourMinute()

        XCTAssertEqual(result, "00:35")
    }

    // 시각 : 2023년 9월 2일 16시 05분
    // 약속 생성 가능 시각 : 2023년 9월 2일 18시 10분
    // 테스트 결과값 : "2023년 9월 2일"
    func test_약속가능시간_생성_날짜_03() throws {
        let date = try createDate(2023, 9, 2, 16, 05)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.koreanDate()

        XCTAssertEqual(result, "2023년 9월 2일")
    }

    // 시각 : 2023년 9월 2일 16시 05분
    // 약속 생성 가능 시각 : 2023년 9월 2일 18시 10분
    // 테스트 결과값 : "18:10"
    func test_약속가능시간_생성_시간_03() throws {
        let date = try createDate(2023, 9, 2, 16, 05)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.hourMinute()

        XCTAssertEqual(result, "18:10")
    }

    // 시각 : 2023년 8월 31일 21시 57분
    // 약속 생성 가능 시각 : 2023년 9월 1일 0시 0분
    // 테스트 결과값 : "2023년 9월 2일"
    func test_약속가능시간_생성_날짜_04() throws {
        let date = try createDate(2023, 8, 31, 21, 57)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.koreanDate()

        XCTAssertEqual(result, "2023년 9월 1일")
    }

    // 시각 : 2023년 8월 31일 21시 57분
    // 약속 생성 가능 시각 : 2023년 9월 1일 0시 0분
    // 테스트 결과값 : "0:00"
    func test_약속가능시간_생성_시간_04() throws {
        let date = try createDate(2023, 8, 31, 21, 57)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.hourMinute()

        XCTAssertEqual(result, "00:00")
    }

    // 시각 : 2023년 12월 31일 21시 57분
    // 약속 생성 가능 시각 : 2024년 1월 1일 0시 0분
    // 테스트 결과값 : "2024년 1월 1일"
    func test_약속가능시간_생성_날짜_05() throws {
        let date = try createDate(2023, 12, 31, 21, 57)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.koreanDate()

        XCTAssertEqual(result, "2024년 1월 1일")
    }

    // 시각 : 2023년 12월 31일 21시 57분
    // 약속 생성 가능 시각 : 2024년 1월 1일 0시 0분
    // 테스트 결과값 : "0:00"
    func test_약속가능시간_생성_시간_05() throws {
        let date = try createDate(2024, 12, 31, 21, 57)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.hourMinute()

        XCTAssertEqual(result, "00:00")
    }

    // 시각 : 2024년 2월 28일 23시 00분
    // 약속 생성 가능 시각 : 2024년 2월 29일 1시 5분
    // 테스트 결과값 : "2024년 2월 29일"
    func test_약속가능시간_생성_날짜_06() throws {
        let date = try createDate(2024, 2, 28, 23, 00)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.koreanDate()

        XCTAssertEqual(result, "2024년 2월 29일")
    }

    // 시각 : 2024년 2월 28일 23시 00분
    // 약속 생성 가능 시각 : 2024년 2월 29일 1시 5분
    // 테스트 결과값 : "01:05"
    func test_약속가능시간_생성_시간_06() throws {
        let date = try createDate(2024, 2, 28, 23, 00)
        let meetingDate = date.meetingStartTime()
        let result = meetingDate.hourMinute()

        XCTAssertEqual(result, "01:05")
    }
}
