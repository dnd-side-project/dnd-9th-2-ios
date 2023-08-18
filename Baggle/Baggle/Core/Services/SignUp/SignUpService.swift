//
//  NicknameService.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

import ComposableArchitecture
import Moya

struct SignUpService {
    var signUp: (SignUpRequestModel, String) async -> SignUpServiceStatus
}

extension SignUpService: DependencyKey {

    static let networkService = NetworkService<UserAPI>()
    
    static var liveValue = Self { requestModel, token  in
        do {
            // 네트워크 요청
            let data: SignEntity = try await networkService.request(
                .signUp(
                    requestModel: requestModel,
                    token: token
                )
            )
            print("data: \(data)")
            

            let user = data.toDomain()
            let token = UserToken(accessToken: data.accessToken, refreshToken: data.refreshToken)
            try UserManager.shared.save(user: user, userToken: token)
            
            return .success
        } catch {
            if (error as? APIError) == APIError.duplicatedNickname {
                return .nicknameDuplicated
            } else if let error = error as? KeyChainError {
                return .keyChainError
            } else {
                return .fail(.network)
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
