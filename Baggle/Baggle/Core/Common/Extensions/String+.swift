//
//  String+Regex.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import UIKit

extension String {

    // MARK: - String 정규식 검사

    func isValidRegex(regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression) != nil
    }

    // MARK: - 맨 마지막 문자 줄바꿈일 때 제거
    func removeTrailingNewlines() -> String {
        return self.filter { $0 != "\n" }
    }

    // MARK: - String 그래픽 width 값
    var width: CGFloat {
        let attributedString = NSAttributedString(
            string: self,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22.0)]
        )
        let stringSize = attributedString.size()
        let widthOfString = stringSize.width

        return widthOfString
    }
    
    func width(_ size: CGFloat) -> CGFloat {
        let attributedString = NSAttributedString(
            string: self,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)]
        )
        let stringSize = attributedString.size()
        let widthOfString = stringSize.width
        return widthOfString
    }
}
