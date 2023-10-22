//
//  NicknameService.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

import ComposableArchitecture

struct SignUpService {
    var signUp: (SignUpRequestModel, String) async -> SignUpServiceResult
}

extension SignUpService: DependencyKey {

    static let networkService = NetworkService<UserAPI>()
    
    static var liveValue = Self { requestModel, token  in
        do {
            return try await Task.retrying {
                let data: SignEntity = try await networkService.request(
                    .signUp(
                        requestModel: requestModel,
                        token: token
                    )
                )
                
                let user = data.toDomain()
                let token = UserToken(
                    accessToken: data.accessToken,
                    refreshToken: data.refreshToken
                )
                try UserManager.shared.save(user: user, userToken: token)
                
                return .success
            }.value
        } catch {
            if (error as? APIError) == APIError.duplicatedNickname {
                return .nicknameDuplicated
            } else if (error as? APIError) == .tokenExpired {
                return .userError
            } else if let error = error as? KeyChainError {
                return .userError
            } else {
                return .networkError(error.localizedDescription)
            }
        }
    }
}

extension DependencyValues {
    var signUpService: SignUpService {
        get { self[SignUpService.self] }
        set { self[SignUpService.self] = newValue }
    }
}
