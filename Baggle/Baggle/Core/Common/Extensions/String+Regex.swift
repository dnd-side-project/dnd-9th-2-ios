//
//  String+Regex.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

// String 정규식 검사

extension String {
    func isValidRegex(regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression) != nil
    }
}
