//
//  KakaoLogin.swift
//  Baggle
//
//  Created by youtak on 2023/08/02.
//

import Foundation

import ComposableArchitecture
import KakaoSDKUser

struct KakaoLoginService {
    var login: () async throws -> String
}

extension KakaoLoginService: DependencyKey {

    typealias TokenContinuation = CheckedContinuation<String, Error>

    static var liveValue = Self {
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
    var kakaoLoginService: KakaoLoginService {
        get { self[KakaoLoginService.self] }
        set { self[KakaoLoginService.self] = newValue }
    }
}
