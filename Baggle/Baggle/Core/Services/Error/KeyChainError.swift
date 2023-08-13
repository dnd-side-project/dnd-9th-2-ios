//
//  KeyChainError.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import Foundation

enum KeyChainError: Error, Equatable {
    case create
    case read
    case update
    case delete
}
