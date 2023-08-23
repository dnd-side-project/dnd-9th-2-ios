//
//  UserManager.swift
//  Baggle
//
//  Created by youtak on 2023/08/18.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    let keychainManager = KeychainManager.shared
    
    private init() {}
    
    var isLoggedIn: Bool {
        UserDefaultList.user != nil
    }
    
    var user: User? {
        UserDefaultList.user
    }
    
    var accessToken: String? {
        do {
            return try KeychainManager.shared.readUserToken().accessToken
        } catch {
            return nil
        }
    }
    
    var refreshToken: String? {
        do {
            return try KeychainManager.shared.readUserToken().refreshToken
        } catch {
            return nil
        }
    }
    
    private func checkKeyChain() {
        do {
            _ = try keychainManager.readUserToken()
            try keychainManager.deleteUserToken()
        } catch {
            return
        }
    }
    
    func save(user: User, userToken: UserToken) throws {
        checkKeyChain()
        try KeychainManager.shared.createUserToken(userToken)
        UserDefaultList.user = user
    }

    func delete() {
        do {
            UserDefaultList.user = nil
            try keychainManager.deleteUserToken()
        } catch {
            print(error) // 삭제 에러 -> 원래 데이터가 없었음 -> 따로 처리 필요 x
        }
    }
}
