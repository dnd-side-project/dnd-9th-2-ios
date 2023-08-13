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
        
        var presentSafariView: Bool = false
        var safariURL: String = ""
    }

    enum Action: Equatable {
        case logoutMyPage

        case notificationSettingButtonTapped
        case privacyPolicyButtonTapped
        case termsOfServiceButtonTapped
        case logoutButtonTapped
        case withdrawButtonTapped
        
        case presentSafariView
    }

    var body: some ReducerProtocolOf<Self> {

        Reduce { state, action in
            switch action {

            case .logoutMyPage:
                do {
                    try KeychainManager.shared.deleteUserToken()
                } catch let error {
                    print("Keychain error - \(error)")
                }
                UserDefaultList.user = nil
                return .none
                
            case .notificationSettingButtonTapped:
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
                return .none
                
            case .privacyPolicyButtonTapped: 
                state.safariURL = "https://www.dnd.ac/"
                state.presentSafariView = true
                return .none
                
            case .termsOfServiceButtonTapped:
                state.safariURL = "https://www.naver.com/"
                state.presentSafariView = true
                return .none
                
            case .logoutButtonTapped:
                return .none

            case .withdrawButtonTapped:
                return .none
                
            case .presentSafariView:
                state.presentSafariView = false
                return .none
            }
        }
    }
}
