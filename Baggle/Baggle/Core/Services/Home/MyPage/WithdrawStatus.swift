//
//  WithdrawStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

enum WithdrawServiceStatus: Equatable {
    case success
    case fail(APIError)
    case keyChainError
}
