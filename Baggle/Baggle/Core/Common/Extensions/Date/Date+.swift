//
//  Date+.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import Foundation

extension Date {

    var calendar: Calendar { Calendar.current }

    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }

    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            // swiftlint:disable:next force_unwrapping
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }

    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            // swiftlint:disable:next force_unwrapping
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }

    var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            // swiftlint:disable:next force_unwrapping
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentHour = calendar.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }

    var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            // swiftlint:disable:next force_unwrapping
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = calendar.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }

    // 현재 시간을 분 단위 까지 나타내주며 생성
    // 초 단위는 짤림
    // ex. 2023년 9월 1일 12시 30분 35.23232초 -> 2023년 9월 1일 12시 30분 00 초
    static func now() -> Date {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        // swiftlint:disable:next force_unwrapping
        return calendar.date(from: component)!
    }

    // format에 해당하는 문자열 리턴
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    /// 한글 년, 월, 일로 날짜 리턴
    /// - Returns: String 타입으로 날짜 리턴 "2023년 8월 1일"
    func koreanDate() -> String {
        let format = "yyyy년 M월 d일"
        return toString(format: format)
    }

    /// 시, 분 리턴
    /// - Returns: String 타입으로 시각 리턴 "21:30"
    func hourMinute() -> String {
        let format = "HH:mm"
        return toString(format: format)
    }

    // n 시간 이후 생성
    func later(hours: Int) -> Date {
        // swiftlint:disable:next force_unwrapping
        let hoursFromNow = Calendar.current.date(byAdding: .hour, value: hours, to: self)!
        return hoursFromNow
    }

    /// 약속 생성 가능 시간 리턴
    /// ex
    /// 2시 03분 -> 2시 05분
    /// 2시 05분 -> 2시 10분
    func meetingStartTime() -> Date {
        // 2시간 이후
        var result = later(hours: 2)
        
        // 2시 5분이면 생성이 불가능 -> 2시 6분으로
        result.minute += 1

        // 2시 10분으로
        while result.minute % 5 != 0 {
            result.minute += 1
        }

        return result
    }

    var canMeeting: Bool {
        return self > Date().later(hours: 2)
    }

    // 인자로 들어온 newDate의 `년`, `월`, `일`로 업데이트 해서 리턴
    func yearMonthDate(of newDate: Date) -> Date {
        var result = self
        result.year = newDate.year
        result.month = newDate.month
        result.day = newDate.day
        return result
    }

    // 인자로 들어온 newDate의 `시간`, "분"으로 업데이트 해서 리턴
    func hourMinute(of newDate: Date) -> Date {
        var result = self
        result.hour = newDate.hour
        result.minute = newDate.minute
        return result
    }
}
