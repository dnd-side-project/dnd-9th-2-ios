//
//  WithdrawService.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import Foundation

import ComposableArchitecture
import Moya

typealias ResponseEmptyData = Bool

struct WithdrawService {
    var withdraw: () async -> WithdrawServiceResult
}

extension WithdrawService: DependencyKey {
    
    static let networkService = NetworkService<UserAPI>()
    
    static var liveValue = Self {
        do {
            guard let token = UserManager.shared.accessToken else {
                return .keyChainError
            }
            // 네트워크로 회원 탈퇴 요청
            try await networkService.requestWithNoResult(.withdraw(token: token))
            
            
            UserManager.shared.delete()
            
            return .success
        } catch {
            guard let error = error as? APIError else {
                return .fail(.network)
            }
            return .fail(error)
        }
    }
}

extension DependencyValues {
    var withdrawService: WithdrawService {
        get { self[WithdrawService.self] }
        set { self[WithdrawService.self] = newValue }
    }
}
    
