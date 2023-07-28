//
//  ContentView.swift
//  promiseDemo
//
//  Created by youtak on 2023/07/17.
//

import SwiftUI

import ComposableArchitecture

struct AppView: View {

    let store: StoreOf<AppFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            if viewStore.isLoggedIn {
                MainTabView(
                    store: self.store.scope(
                        state: \.mainTabFeature,
                        action: AppFeature.Action.logout
                    )
                )
            } else {
                LoginView(
                    store: self.store.scope(
                        state: \.loginFeature,
                        action: AppFeature.Action.login
                    )
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store:
                    Store(
                        initialState: AppFeature.State(
                            isLoggedIn: true,
                            loginFeature: LoginFeature.State(),
                            mainTabFeature: MainTabFeature.State(
                                myPageFeature: MyPageFeature.State()
                            )
                        ),
                        reducer: AppFeature()
                )
        )
    }
}
