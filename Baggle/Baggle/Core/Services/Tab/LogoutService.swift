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
                return .userError
            }
            
            try await networkService.requestWithNoResult(.signOut(token: token))
            UserManager.shared.delete()
            
            return .success
        } catch {
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
