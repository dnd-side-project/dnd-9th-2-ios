//
//  SignUpServiceStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

enum SignUpServiceResult {
    case success
    case nicknameDuplicated
    case networkError(String)
    case userError
}
