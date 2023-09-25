//
//  WithdrawStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

enum WithdrawServiceResult: Equatable {
    case success
    case networkError(String)
    case userError
}
