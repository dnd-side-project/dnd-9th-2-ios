//
//  WithdrawService.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import Foundation

import ComposableArchitecture
import Moya

struct WithdrawService {
    var withdraw: () async -> WithdrawServiceStatus
}

extension WithdrawService: DependencyKey {
    static var liveValue = Self {
        return await WithdrawRepository().withdraw()
    }
}

extension DependencyValues {
    var withdrawService: WithdrawService {
        get { self[WithdrawService.self] }
        set { self[WithdrawService.self] = newValue }
    }
}
