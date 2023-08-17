//
//  MyPageFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import SwiftUI

import ComposableArchitecture

struct MyPageFeature: ReducerProtocol {

    struct State: Equatable {
        var user = UserDefaultList.user ?? User.error()
        
        var isLoading: Bool = false
        var presentSafariView: Bool = false
        var safariURL: String = ""
    }

    enum Action: Equatable {
        case onAppear
        
        case logoutMyPage

        case notificationSettingButtonTapped
        case privacyPolicyButtonTapped
        case termsOfServiceButtonTapped
        case logoutButtonTapped
        case withdrawButtonTapped
        
        case withdrawResult(WithdrawServiceStatus)
        
        case presentSafariView
        case delegate(Delegate)
        enum Delegate {
            case moveToLogin
        }
    }

    @Dependency(\.withdrawService) var withdrawService
    
    var body: some ReducerProtocolOf<Self> {

        Reduce { state, action in
            switch action {
            case .onAppear:
                state.user = UserDefaultList.user ?? User.error()
                return .none

            case .logoutMyPage:
                return .none
                
            case .notificationSettingButtonTapped:
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
                return .none
                
            case .privacyPolicyButtonTapped: 
                state.safariURL = Const.URL.privacyPolicy
                state.presentSafariView = true
                return .none
                
            case .termsOfServiceButtonTapped:
                state.safariURL = Const.URL.termsOfService
                state.presentSafariView = true
                return .none
                
            case .logoutButtonTapped:
                // 임시 로그아웃 연결
                do {
                    try KeychainManager.shared.deleteUserToken()
                } catch let error {
                    print("Keychain error - \(error)")
                }
                UserDefaultList.user = nil
                return .run { send in await send(.delegate(.moveToLogin)) }
                
            case .withdrawButtonTapped:
                state.isLoading = true
                return .run { send in
                    let withdrawStatus = await withdrawService.withdraw()
                    await send(.withdrawResult(withdrawStatus))
                }
                
            case let .withdrawResult(status):
                state.isLoading = false
                switch status {
                case .success:
                    print("성공")
                    return .run { send in await send(.delegate(.moveToLogin)) }
                case let .fail(apiError):
                    print("API Error \(apiError)")
                case .keyChainError:
                    print("키체인 에러")
                }
                return .none
                
            case .presentSafariView:
                state.presentSafariView = false
                return .none
                
            case .delegate(.moveToLogin):
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
