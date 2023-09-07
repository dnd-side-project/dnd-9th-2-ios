//
//  KakaoLogin.swift
//  Baggle
//
//  Created by youtak on 2023/08/02.
//

import Foundation

import ComposableArchitecture
import KakaoSDKUser

struct LoginService {
    var login: (LoginRequestModel, String) async -> LoginServiceResult
    var kakaoLogin: () async throws -> String
}

extension LoginService: DependencyKey {
    
    static let networkService = NetworkService<UserAPI>()
    typealias TokenContinuation = CheckedContinuation<String, Error>

    static var liveValue = Self { requestModel, token in
        do {
            let data: SignEntity = try await networkService.request(
                .signIn(
                    requestModel: requestModel,
                    token: token
                )
            )

            let user = data.toDomain()
            let token = UserToken(accessToken: data.accessToken, refreshToken: data.refreshToken)
            try UserManager.shared.save(user: user, userToken: token)
            
            return .success
        } catch let error {
            if let apiError = error as? APIError {
                if apiError == .notFound {
                    return .requireSignUp
                }
            } else if let userError = error as? KeyChainError {
                return .userError
            }
            
            return .networkError(error.localizedDescription)
        }
    } kakaoLogin: {
        return try await withCheckedThrowingContinuation({ (continuation: TokenContinuation) in
            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                        if let error {
                            dump(error)
                            continuation.resume(throwing: error)
                        } else {
                            if let accessToken = oauthToken?.accessToken {
                                continuation.resume(returning: accessToken)
                            }
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        if let error {
                            dump(error)
                            continuation.resume(throwing: error)
                        } else {
                            if let accessToken = oauthToken?.accessToken {
                                continuation.resume(returning: accessToken)
                            }
                        }
                    }
                }
            }
        })
    }
}

extension DependencyValues {
    var loginService: LoginService {
        get { self[LoginService.self] }
        set { self[LoginService.self] = newValue }
    }
}
