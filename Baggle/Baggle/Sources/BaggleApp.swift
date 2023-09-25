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

@main
struct BaggleApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        let kakaoNativeAppKey = Bundle.main.object(forInfoDictionaryKey: "AppKey") as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
    }

    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppFeature.State(
                        isLoggedIn: UserManager.shared.isLoggedIn,
                        loginFeature: LoginFeature.State(),
                        mainTabFeature: MainTabFeature.State(
                            selectedTab: .home,
                            homeFeature: HomeFeature.State(),
                            myPageFeature: MyPageFeature.State()
                        )
                    ),
                    reducer: AppFeature()
                )
            )
            .onOpenURL { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
                
                if let id = url.params()?["id"] as? String,
                   let id = Int(id) {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        self.postObserverAction(.skipSplashJoinMeeting, object: id)
                    }
                    print("카카오톡 타고 들어온 Meeting ID : \(id)")
                }
            }
        }
    }
}
