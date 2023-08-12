//
//  KakaoLogin.swift
//  Baggle
//
//  Created by youtak on 2023/08/02.
//

import Foundation

import ComposableArchitecture
import KakaoSDKUser

enum LoginServiceState {
    case success
    case requireSignUp
    case fail(APIError)
}

struct LoginService {
    var login: (LoginRequestModel, String) async -> LoginServiceState
    var kakaoLogin: () async throws -> String
}

extension LoginService: DependencyKey {
    
    static let networkService = BaseService<UserAPI>()
    typealias TokenContinuation = CheckedContinuation<String, Error>

    static var liveValue = Self { requestModel, token in
        do {
            let data: SignEntity = try await networkService.request(.signIn(
                requestModel: requestModel,
                token: token))
            let token = UserToken(accessToken: data.accessToken, refreshToken: data.refreshToken)
            if KeychainManager.shared.readUserToken() == nil {
                try KeychainManager.shared.deleteUserToken()
            }
            try KeychainManager.shared.createUserToken(token)
            
            UserDefaultList.user = data.toDomain()
            return .success
        } catch let error {
            print("LoginService - error: \(error)")
            if (error as? APIError) == APIError.notFound {
                return .requireSignUp
            } else {
                return .fail(.network)
            }
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
