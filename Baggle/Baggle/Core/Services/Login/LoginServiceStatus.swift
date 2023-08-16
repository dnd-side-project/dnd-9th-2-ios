//
//  LoginServiceStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

enum LoginServiceStatus {
    case success
    case requireSignUp
    case fail(APIError)
}
