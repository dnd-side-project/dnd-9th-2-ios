//
//  MyPageFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import ComposableArchitecture

struct MyPageFeature: ReducerProtocol {

    struct State: Equatable {
    }

    enum Action: Equatable {
        case logoutMyPage
    }

    var body: some ReducerProtocolOf<Self> {

        Reduce { _, action in
            switch action {

            case .logoutMyPage:
                KeychainManager.shared.deleteUserToken()
                UserDefaultList.user = nil
                return .none
            }
        }
    }
}
