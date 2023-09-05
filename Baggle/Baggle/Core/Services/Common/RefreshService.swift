//
//  RefreshService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/05.
//

import Foundation

import ComposableArchitecture
import Moya

struct RefreshService {
    var refresh: () async -> RefreshServiceResult
}

extension RefreshService: DependencyKey {
    
    static let networkService = NetworkService<UserAPI>()
    
    static var liveValue = Self {
        do {
            print("🔄 token expired - renewing")
            
            guard let refreshToken = UserManager.shared.refreshToken else { return .keyChainError }
            guard let user = UserManager.shared.user else { return .keyChainError }
            
            let data: RefreshEntity = try await networkService.request(
                .reissue(token: refreshToken)
            )
            let token = UserToken(accessToken: data.accessToken, refreshToken: data.refreshToken)
            
            try UserManager.shared.save(user: user, userToken: token)
            
            return .success
        } catch {
            return .fail
        }
    }
}

extension DependencyValues {
    var refreshService: RefreshService {
        get { self[RefreshService.self] }
        set { self[RefreshService.self] = newValue }
    }
}
