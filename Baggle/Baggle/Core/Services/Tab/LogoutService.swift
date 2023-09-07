//
//  LogoutService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/03.
//

import Foundation

import ComposableArchitecture

struct LogoutService {
    var logout: () async -> LogoutServiceResult
}

extension LogoutService: DependencyKey {
    
    static let networkService = NetworkService<UserAPI>()
    
    static var liveValue = Self {
        do {
            guard let token = UserManager.shared.accessToken else {
                return .keyChainError
            }
            
            try await networkService.requestWithNoResult(.signOut(token: token))
            UserManager.shared.delete()
            
            return .success
        } catch let error {
            guard let error = error as? APIError else {
                return .fail(.network)
            }
            return .fail(error)
        }
    }
}

extension DependencyValues {
    var logoutService: LogoutService {
        get { self[LogoutService.self] }
        set { self[LogoutService.self] = newValue }
    }
}
