//
//  NicknameValidator.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

import ComposableArchitecture

struct NicknameValidator {
    var isValidate: (String) -> Bool
}

extension NicknameValidator: DependencyKey {

    static let nicknameRegex = "^[가-힣a-zA-Z0-9_-]{2,10}$"

    static var liveValue = Self { text in
        return text.isValidRegex(regex: nicknameRegex)
    }
}

extension DependencyValues {
    var nicknameValidator: NicknameValidator {
        get { self[NicknameValidator.self] }
        set { self[NicknameValidator.self] = newValue }
    }
}
