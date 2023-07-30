//
//  BaggleApp.swift
//  Baggle
//
//  Created by youtak on 2023/07/17.
//

import SwiftUI

import ComposableArchitecture
import KakaoSDKAuth
import KakaoSDKCommon
import FirebaseCore

@main
struct BaggleApp: App {

    init() {
        let kakaoNativeAppKey = Bundle.main.object(forInfoDictionaryKey: "AppKey") as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppFeature.State(
                        isLoggedIn: false,
                        loginFeature: LoginFeature.State(),
                        mainTabFeature: MainTabFeature.State(
                            selectedTab: .home,
                            myPageFeature: MyPageFeature.State()
                        )
                    ),
                    reducer: AppFeature()
                )
            )
            .onOpenURL { url in
                print("url: \(url)")
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
    }
}
