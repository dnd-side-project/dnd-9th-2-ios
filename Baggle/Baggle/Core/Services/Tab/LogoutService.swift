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
            return try await Task.retrying {
                guard let token = UserManager.shared.accessToken else {
                    return .userError
                }
                
                try await networkService.requestWithNoResult(.signOut(token: token))
                UserManager.shared.delete()
                
                return .success
            }.value
        } catch {
            if error as? APIError == APIError.tokenExpired {
                return .userError
            }
            return .networkError(error.localizedDescription)
        }
    }
}

extension DependencyValues {
    var logoutService: LogoutService {
        get { self[LogoutService.self] }
        set { self[LogoutService.self] = newValue }
    }
}
