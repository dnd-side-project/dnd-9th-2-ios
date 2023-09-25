//
//  WithdrawService.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import Foundation

import ComposableArchitecture

typealias ResponseEmptyData = Bool

struct WithdrawService {
    var withdraw: () async -> WithdrawServiceResult
}

extension WithdrawService: DependencyKey {
    
    static let networkService = NetworkService<UserAPI>()
    
    static var liveValue = Self {
        do {
            return try await Task.retrying {
                guard let token = UserManager.shared.accessToken else {
                    return .userError
                }
                
                try await networkService.requestWithNoResult(.withdraw(token: token))
                
                UserManager.shared.delete()
                
                return .success
            }.value
        } catch {
            return .networkError(error.localizedDescription)
        }
    }
}

extension DependencyValues {
    var withdrawService: WithdrawService {
        get { self[WithdrawService.self] }
        set { self[WithdrawService.self] = newValue }
    }
}
    
