//
//  MyPageFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import ComposableArchitecture

struct MyPageFeature: ReducerProtocol {

    struct State: Equatable {
        var user = UserDefaultList.user ?? User(id: -1, name: "에러", profileImageURL: "", platform: .apple)
    }

    enum Action: Equatable {
        case logoutMyPage
    }

    var body: some ReducerProtocolOf<Self> {

        Reduce { _, action in
            switch action {

            case .logoutMyPage:
                do {
                    try KeychainManager.shared.deleteUserToken()
                } catch let error {
                    print("Keychain error - \(error)")
                }
                UserDefaultList.user = nil
                return .none
            }
        }
    }
}
