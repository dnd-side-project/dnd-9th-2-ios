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
    
    // MARK: - 최대 글자수 기준 줄바꿈한 문자열 생성
    /// maxCount(기본 11)이상의 글자수이면 줄바꿈해주는 함수
    func lineChanged(_ maxCount: Int = 11) -> String {
        if self.count <= maxCount {
            return self
        } else {
            // 최대 글자수보다 크면 줄바꿈한 문자열 리턴
            var newStr = ""
            var length = 0
            let truncatedStr = self.split(separator: " ")
            
            for str in truncatedStr.enumerated() {
                length += str.element.count
                // 한 줄에 들어갈 글자수가 maxCount보다 크면 줄바꿈, 아니면 그대로 newStr 추가
                if length >= maxCount {
                    if str.offset == 0 {
                        var copyStr = str.element
                        newStr += copyStr.prefix(maxCount) + "\n"
                        copyStr.removeFirst(maxCount)
                        newStr += copyStr
                        length = copyStr.count
                        continue
                    } else {
                        newStr += "\n"
                        length = 0
                    }
                }
                newStr += str.element + " "
            }
            return newStr
        }
    }
}
