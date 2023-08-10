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
            return try await SignUpRepository().signUp(requestModel: requestModel)
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
    private let networkService = DefaultUserService()
    
    func signUp(requestModel: SignUpRequestModel) async throws -> SignUpServiceState {
        return try await withCheckedThrowingContinuation({ continuation in
            print("requestModel - \(requestModel)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if requestModel.nickname == "중복" || requestModel.nickname == "Baggle" {
                    continuation.resume(returning: .nicknameDuplicated)
                } else if requestModel.nickname == "에러" || requestModel.nickname == "Error" {
                    continuation.resume(throwing: NetworkError.badRequest)
                } else {
                    continuation.resume(returning: .success)
                }
            }
            
//            networkService.postSignUp(requestModel: requestModel) { result in
//                print("result: \(result)")
//            }
        })
    }
}
