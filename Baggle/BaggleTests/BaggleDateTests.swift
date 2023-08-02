//
//  BaggleTests.swift
//  BaggleTests
//
//  Created by youtak on 2023/08/01.
//

import XCTest

@testable import Baggle

final class BaggleDateTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    // MARK: - 한글 출력
    // 화면에 보일 한글 날짜

    // 시각 : 2023년 09월 01일 12시 30분
    // 결과 : "2023년 9월 1일"
    func test_한글출력_날짜_01() throws {
        let calendar = Calendar(identifier: .gregorian)
        let targetDateComponents = DateComponents(year: 2023, month: 9, day: 1, hour: 12, minute: 30)
        let targetDate = calendar.date(from: targetDateComponents)
        let date = try XCTUnwrap(targetDate)

        let result = date.koreanDate()
        XCTAssertEqual(result, "2023년 9월 1일")
    }

    // 시각 : 2023년 09월 01일 12시 30분
    // 결과 : "12:30"
    func test_한글출력_시간_01() throws {
        let calendar = Calendar(identifier: .gregorian)
        let targetDateComponents = DateComponents(year: 2023, month: 9, day: 1, hour: 12, minute: 30)
        let targetDate = calendar.date(from: targetDateComponents)
        let date = try XCTUnwrap(targetDate)

        let result = date.hourMinute()
        XCTAssertEqual(result, "12:30")
    }

    // 시각 : 2023년 8월 5일 18시 50분
    // 약속 생성 가능 시각 : 2023년 8월 5일 21시 00분
    func test_약속가능시간_생성_01() throws {
        let calendar = Calendar(identifier: .gregorian)
        let targetDateComponents = DateComponents(year: 2023, month: 8, day: 5, hour: 18, minute: 50)
        let targetDate = calendar.date(from: targetDateComponents)
        let date = try XCTUnwrap(targetDate)

        let meetingDate = date.meetingStartTime()
        let result = meetingDate.koreanDate()
        XCTAssertEqual(result, "2023년 8월 5일")
    }

    // 시각 : 2023년 8월 20일 09시 30분
    // 약속 생성 가능 시각 : 2023년 8월 20일 12시 00분
    func test_약속가능시간_생성_02() throws {
        let calendar = Calendar(identifier: .gregorian)
        let targetDateComponents = DateComponents(year: 2023, month: 8, day: 20, hour: 09, minute: 30)
        let targetDate = calendar.date(from: targetDateComponents)
        let date = try XCTUnwrap(targetDate)

        let meetingDate = date.meetingStartTime()
        let result = meetingDate.koreanDate()
        XCTAssertEqual(result, "2023년 8월 20일")
    }

    // 시각 : 2023년 8월 24일 22시 20분
    // 약속 생성 가능 시각 : 2023년 8월 25일 00시 30분
    func test_약속가능시간_생성_03() throws {
        let calendar = Calendar(identifier: .gregorian)
        let targetDateComponents = DateComponents(year: 2023, month: 8, day: 24, hour: 22, minute: 20)
        let targetDate = calendar.date(from: targetDateComponents)
        let date = try XCTUnwrap(targetDate)

        let meetingDate = date.meetingStartTime()
        let result = meetingDate.koreanDate()
        XCTAssertEqual(result, "2023년 8월 25일")
    }
}
