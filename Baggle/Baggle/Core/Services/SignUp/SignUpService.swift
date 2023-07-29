//
//  NicknameService.swift
//  Baggle
//
//  Created by youtak on 2023/07/29.
//

import Foundation

import ComposableArchitecture

enum SignUpServiceState {
    case success
    case fail
    case nicknameDuplicated
}

struct SignUpService {
    var signUp: (String) async -> SignUpServiceState
}

extension SignUpService: DependencyKey {

    static var liveValue = Self { nickname in
        do {
            return try await MockUpSignUpService().signUp(nickname: nickname)
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

struct MockUpSignUpService {

    func signUp(nickname: String) async throws -> SignUpServiceState {
        return try await withCheckedThrowingContinuation({ continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if nickname == "중복" || nickname == "Baggle" {
                    continuation.resume(returning: .nicknameDuplicated)
                } else if nickname == "에러" || nickname == "Error" {
                    continuation.resume(throwing: NetworkError.badRequest)
                } else {
                    continuation.resume(returning: .success)
                }
            }
        })
    }
}
