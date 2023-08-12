//
//  WithdrawRepository.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import Foundation

typealias ResponseNull = String?

struct WithdrawRepository {
    private let networkService = BaseService<UserAPI>()
    
    func withdraw() async -> WithdrawServiceStatus {
        do {
            // 키체인에서 토큰 불러옴
            guard let userToken = KeychainManager.shared.readUserToken() else {
                return .keyChainError
            }
            let token = userToken.accessToken
            print(token)
            // 네트워크로 회원 탈퇴 요청
            let _: ResponseNull = try await networkService.request(.withdraw(token: token))
            print("네트워크 삭제")
            // 키체인 토큰 삭제
            try KeychainManager.shared.deleteUserToken()
            print("키체인 삭제")
            // 로컬 유저 정보 삭제
            UserDefaultList.user = nil
            
            return .success
        } catch {
            if let apiError = error as? APIError {
                return .fail(apiError)
            }
            return .keyChainError
        }
    }
}
