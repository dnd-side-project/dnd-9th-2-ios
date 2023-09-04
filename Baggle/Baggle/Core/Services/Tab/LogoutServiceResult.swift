//
//  LogoutServiceResult.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/03.
//

import Foundation

enum LogoutServiceResult: Equatable {
    case success
    case fail(APIError)
    case keyChainError
}
