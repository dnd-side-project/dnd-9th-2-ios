//
//  Date+.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import Foundation

// MARK: - Properties

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
}

// MARK: - Methods
// String으로 리턴해주는 메소드

extension Date {

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
}

// MARK: - Methods
// Date 생성해주는 메소드

extension Date {

    // 현재 시간을 분 단위 까지 나타내주며 생성
    // 초 단위는 짤림
    // ex. 2023년 9월 1일 12시 30분 35.23232초 -> 2023년 9월 1일 12시 30분 00 초

    static func now() -> Date {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        // swiftlint:disable:next force_unwrapping
        return calendar.date(from: component)!
    }
    
    // n 시간 이후 생성

    func later(hours: Int) -> Date {
        // swiftlint:disable:next force_unwrapping
        let hoursFromNow = Calendar.current.date(byAdding: .hour, value: hours, to: self)!
        return hoursFromNow
    }

    // n 분 이후 생성

    func later(minutes: Int) -> Date {
        // swiftlint:disable:next force_unwrapping
        let minutesFromNow = Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
        return minutesFromNow
    }

    // n 초 이후 생성

    func later(seconds: Int) -> Date {
        // swiftlint:disable:next force_unwrapping
        let secondsFromNow = Calendar.current.date(byAdding: .second, value: seconds, to: self)!
        return secondsFromNow
    }

    // n 시간 이전 생성

    func before(hours: Int) -> Date {
        // swiftlint:disable:next force_unwrapping
        let hoursFromNow = Calendar.current.date(byAdding: .hour, value: -hours, to: self)!
        return hoursFromNow
    }

    // n 분 이전 생성

    func before(minutes: Int) -> Date {
        // swiftlint:disable:next force_unwrapping
        let minutesFromNow = Calendar.current.date(byAdding: .minute, value: -minutes, to: self)!
        return minutesFromNow
    }

    // n 초 이전 생성

    func before(seconds: Int) -> Date {
        // swiftlint:disable:next force_unwrapping
        let secondsFromNow = Calendar.current.date(byAdding: .second, value: -seconds, to: self)!
        return secondsFromNow
    }
    

    /// 약속 생성 가능 시간 리턴
    /// ex
    /// 2시 03분 -> 2시 10분
    /// 2시 05분 -> 2시 15분

    func meetingStartTime() -> Date {

        // 2시간 이후
        let twoHoursLater = self.later(hours: 2)

        // 5분 이후
        var twoHoursFiveMinutesLater = twoHoursLater.later(minutes: 10)

        // 5분 단위로 만들기
        while twoHoursFiveMinutesLater.minute % 5 != 0 {
            twoHoursFiveMinutesLater.minute -= 1
        }

        return twoHoursFiveMinutesLater
    }


    // Date Picker에서 사용
    
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

// MARK: - 모임 로직

extension Date {

    // 모임 생성 가능한 시간 여부

    var canMeeting: Bool {
        return self > Date().later(hours: 2)
    }

    // Self가 다가올 날짜인지
    ///
    /// 오늘을 포함하지 않는 미래를 판별합니다. 다가오는 약속인지 확인하기 위해 사용합니다.
    ///
    /// Self : 2023년 8월 31일
    /// 지금 : 2023년 8월 9일
    /// result: true

    func isUpcomingDays(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: date)
        let comparisonResult = calendar.compare(self, to: currentDate, toGranularity: .day)

        return comparisonResult == .orderedDescending
    }
    
    var isUpcomingDays: Bool {
        return isUpcomingDays(Date())
    }


    // Self가 오늘 날짜와 동일한지
    ///
    /// 오늘 날짜(Date)와 동일한지 판별합니다. 약속 당일인지를 확인하기 위해 사용합니다
    
    var isInToday: Bool {
        return calendar.isDateInToday(self)
    }
    
    
    // Self가 지금 시간으로부터 1시간 이내에 진입했는지 확인합니다. (Self - 1시간 <= 지금 )
    ///
    /// 약속 확정인지 확인하기 위해 사용합니다.
    ///
    /// Self : 18시 30분  -> Self - 1 시간: 17시 30분
    /// 지금 : 17시 32분 -> 지금
    /// result : true
    
    func inTheNextHour(_ date: Date) -> Bool {
        return self <= date.later(hours: 1)
    }
    
    var inTheNextHour: Bool {
        return inTheNextHour(Date())
    }


    // Self가 과거 날짜인지
    /// Self가 오늘보다 이전 날짜인지 판별합니다. 지난 약속인지 확인하기 위해 사용합니다.

    func isPreviousDays(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: date)
        let comparisonResult = calendar.compare(self, to: currentDate, toGranularity: .day)

        return comparisonResult == .orderedAscending
    }
    
    var isPreviousDays: Bool {
        return isPreviousDays(Date())
    }
}

// MARK: - 타이머
extension Date {

    func authenticationTimeout() -> Int {
        self.later(minutes: 5).remainingTime()
    }
    
    
    func remainingTime() -> Int {
        let components = calendar.dateComponents([.second], from: Date(), to: self)
        if let result = components.second, result > 0 {
            return result
        } else {
            return 0
        }
    }
}


#if DEBUG
extension Date {
    static func createDate(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
        let targetDateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        let targetDate = Calendar.current.date(from: targetDateComponents)
        return targetDate!
    }
}
#endif
