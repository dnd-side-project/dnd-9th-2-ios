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
    case fail
    case nicknameDuplicated
}

struct SignUpService {
    var signUp: (SignUpRequestModel) async -> SignUpServiceState
}

extension SignUpService: DependencyKey {

    static var liveValue = Self { requestModel in
        do {
            return try await SignUpRepository().fetchSignUp(requestModel: requestModel)
        } catch {
            return SignUpServiceState.fail
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
    
    func fetchSignUp(requestModel: SignUpRequestModel) async throws -> SignUpServiceState {
        print("📍requestModel: \(requestModel)")
        
        do {
            let data: SignUpEntity = try await networkService.request(.signUp(requestModel: requestModel))
            print("data: \(data)")
            // userDefault 저장
            return .success
        } catch let error {
            print("SignUpRepository - error: \(error)")
            // error에 따라 분기처리
//            return .fail
            return .success
        }
    }
}
