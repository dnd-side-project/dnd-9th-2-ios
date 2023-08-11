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
}

struct SignUpService {
    var signUp: (SignUpRequestModel, String) async -> SignUpServiceState
}

extension SignUpService: DependencyKey {

    static var liveValue = Self { requestModel, token  in
        do {
            return try await SignUpRepository().fetchSignUp(requestModel: requestModel,
                                                            token: token)
        } catch let error {
            return SignUpServiceState.fail(.networkErr)
        }
    }
}

extension DependencyValues {
    var signUpService: SignUpService {
        get { self[SignUpService.self] }
        set { self[SignUpService.self] = newValue }
    }
}

struct SignUpRepository {
    private let networkService = BaseService<UserAPI>()
    
    func fetchSignUp(
        requestModel: SignUpRequestModel,
        token: String
    ) async throws -> SignUpServiceState {
        print("📍requestModel: \(requestModel)")
        
        do {
            let data: SignUpEntity = try await networkService.request(.signUp(
                requestModel: requestModel,
                token: token))
            print("data: \(data)")
            
            let token = UserToken(accessToken: data.accessToken, refreshToken: data.refreshToken)
            if KeychainManager.shared.readUserToken() == nil {
                KeychainManager.shared.deleteUserToken()
            }

            if KeychainManager.shared.createUserToken(token) {
                // 키체인 등록 실패한 경우, 업데이트 시도
                print("Keychain - create failed")
            }

            UserDefaultList.user = User(id: data.userID,
                                        name: data.nickname,
                                        profileImageURL: data.profileImageUrl,
                                        platform: data.platform == "apple" ? .apple : .kakao)
            // TODO: - 확인 후 삭제
            print("🔔 keychain: \(KeychainManager.shared.readUserToken())")
            print("🔔 userdefault: \(UserDefaultList.user)")
            
            return .success
        } catch let error {
            print("SignUpRepository - error: \(error)")
            if (error as? APIError) == APIError.duplicatedNicknameErr {
                return .nicknameDuplicated
            } else {
                return .fail(.networkErr)
            }
        }
    }
}
