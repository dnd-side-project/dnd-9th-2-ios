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
            // userDefault 저장
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
