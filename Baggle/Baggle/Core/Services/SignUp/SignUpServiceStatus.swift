//
//  SignUpServiceStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

enum SignUpServiceStatus {
    case success
    case fail(APIError)
    case nicknameDuplicated
    case keyChainError
}
