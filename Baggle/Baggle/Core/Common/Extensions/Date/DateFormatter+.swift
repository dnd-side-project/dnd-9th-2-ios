//
//  DateFormatter+.swift
//  Baggle
//
//  Created by youtak on 2023/08/15.
//

import Foundation

extension DateFormatter {
    static let baggleFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.locale = Locale(identifier: "ko_kr")
        return formatter
    }()
}
