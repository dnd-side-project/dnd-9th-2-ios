//
//  UserDefaultKey.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/25.
//

import Foundation

/**
 - description:
        
        UserDefault를 키 값으로 관리하고 사용하기 위한 요소입니다.
 
 - note:
 
        // 값 추가
        UserDefaultList.count = 1
 
        // 값 삭제
        UserDefaultList.count = nil
 
        // AppStorage를 사용할 경우
        // UserDefalueKey로부터 String 값을 갖고 UserDefaultList의 값을 대입하여 사용할 수 있습니다.
        @AppStorage(UserDefaultKey.count.rawValue) var count: Int = (UserDefaultList.count ?? 0)
    
 */

enum UserDefaultKey {
    case user
    case fcmToken
    case isOnboarding

    var rawValue: String {
        switch self {
        case .user: return "user"
        case .fcmToken: return "fcmToken"
        case .isOnboarding: return "isOnboarding"
        }
    }
}

public struct UserDefaultManager {
    @UserDefaultWrapper<User>(key: .user) public static var user
    @UserDefaultWrapper<String>(key: .fcmToken) public static var fcmToken
    @UserDefaultWrapper<Bool>(key: .isOnboarding, defaultValue: true) public static var isOnboarding
}
