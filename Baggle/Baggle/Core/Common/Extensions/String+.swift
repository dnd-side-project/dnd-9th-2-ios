//
//  String+Regex.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

extension String {

    // MARK: - String 정규식 검사

    func isValidRegex(regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression) != nil
    }

    // MARK: - 맨 마지막 문자 줄바꿈일 때 제거
    func removeTrailingNewlines() -> String {
        return self.filter { $0 != "\n" }
    }
}
