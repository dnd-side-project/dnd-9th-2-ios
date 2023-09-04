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
        
        case presentSafariView
        case delegate(Delegate)
        enum Delegate {
            case presentLogout
            case presentWithdraw
            case moveToLogin
        }
    }
    
    var body: some ReducerProtocolOf<Self> {

        Reduce { state, action in
            switch action {
            case .onAppear:
                state.user = UserManager.shared.user ?? User.error()
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
                return .run { send in await send(.delegate(.presentLogout)) }
                
            case .withdrawButtonTapped:
                return .run { send in await send(.delegate(.presentWithdraw)) }
                
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
