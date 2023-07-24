//
//  promiseDemoApp.swift
//  promiseDemo
//
//  Created by youtak on 2023/07/17.
//

import SwiftUI

import ComposableArchitecture

@main
struct PromiseDemoApp: App {
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
        }
    }
}
