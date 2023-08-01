//
//  Date+.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import Foundation

extension Date {

    var calendar: Calendar { Calendar.current }

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

    /// 약속 생성 가능 시간 리턴
    func meetingStartTime() -> Date {
        // 2시간 이후
        let hours = 2
        let hoursFromNow = Calendar.current.date(byAdding: .hour, value: hours, to: self)!

        // 2시간 이후 가장 가까운 30분 혹은 00분

        return hoursFromNow
    }
}
