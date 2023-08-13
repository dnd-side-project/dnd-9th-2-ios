//
//  NicknameService.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

import ComposableArchitecture
import Moya

enum SignUpServiceState {
    case success
    case fail(APIError)
    case nicknameDuplicated
    case keyChainError
}

struct SignUpService {
    var signUp: (SignUpRequestModel, String) async -> SignUpServiceState
}

extension SignUpService: DependencyKey {

    static let baseService = BaseService<UserAPI>()
    
    static var liveValue = Self { requestModel, token  in
        do {
            // 네트워크 요청
            let data: SignEntity = try await baseService.request(
                .signUp(
                    requestModel: requestModel,
                    token: token
                )
            )
            print("data: \(data)")
            
            // 키체인 저장, 저장 전에 이미 있는 데이터  삭제
            checkKeyChain()
            let token = UserToken(accessToken: data.accessToken, refreshToken: data.refreshToken)
            try KeychainManager.shared.createUserToken(token)
            
            // 유저 Default 저장
            saveUser(data: data.toDomain())
            
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

    static func checkKeyChain() {
        do {
            _ = try KeychainManager.shared.readUserToken()
            try KeychainManager.shared.deleteUserToken()
        } catch {
            return
        }
    }
    
    static func saveUser(data: User) {
        UserDefaultList.user = data
    }
}

extension DependencyValues {
    var signUpService: SignUpService {
        get { self[SignUpService.self] }
        set { self[SignUpService.self] = newValue }
    }
}
