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
                        isLoggedIn: true,
                        loginFeature: LoginFeature.State()
                    ),
                    reducer: AppFeature()
                )
            )
        }
    }
}
