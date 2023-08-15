//
//  WithdrawService.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import Foundation

import ComposableArchitecture
import Moya

typealias ResponseEmptyData = Bool

struct WithdrawService {
    var withdraw: () async -> WithdrawServiceStatus
}

extension WithdrawService: DependencyKey {
    
    static let networkService = NetworkService<UserAPI>()
    
    static var liveValue = Self {
        do {
            // 키체인에서 토큰 불러옴
            let userToken = try KeychainManager.shared.readUserToken()

            let token = userToken.accessToken
            // 네트워크로 회원 탈퇴 요청
            let _: ResponseEmptyData = try await networkService.request(.withdraw(token: token))
            
            // 로컬 유저 정보 삭제
            UserDefaultList.user = nil

            // 키체인 토큰 삭제
            try KeychainManager.shared.deleteUserToken()
            
            return .success
        } catch {
            if let apiError = error as? APIError {
                return .fail(apiError)
            } else {
                return .keyChainError
            }
        }
    }
}

extension DependencyValues {
    var withdrawService: WithdrawService {
        get { self[WithdrawService.self] }
        set { self[WithdrawService.self] = newValue }
    }
}
    
