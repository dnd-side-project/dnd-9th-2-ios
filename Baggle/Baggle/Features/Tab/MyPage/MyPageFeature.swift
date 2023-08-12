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
        case withdrawButtonTapped
    }

    var body: some ReducerProtocolOf<Self> {

        Reduce { _, action in
            switch action {

            case .withdrawButtonTapped:
                do {
                    // 키체인에서 토큰 불러옴
                    // 네트워크로 회원 탈퇴 요청
                    // 키체인 토큰 삭제
                    // 로컬 유저 정보 삭제
                    //UserDefaultList.user = nil
//                    try KeychainManager.shared.deleteUserToken()
                } catch let error {
                    print("Keychain error - \(error)")
                }
                return .none
            }
        }
    }
}
