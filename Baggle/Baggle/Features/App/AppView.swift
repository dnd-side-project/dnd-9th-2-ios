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

    @State var splashStarted: Bool = false
    @State var splashEnded: Bool = false

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            if splashEnded {
                Group {
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
                .transition(.move(edge: .trailing).animation(.easeInOut(duration: 0.4)))
            } else {
                Image.Logo.large
                    .opacity(splashStarted ? 1 : 0)
                    .offset(y: splashStarted ? 0 : +10)
                    .animation(.easeInOut(duration: 0.3).delay(0.5), value: splashStarted)
            }
        }
        .onAppear {
            withAnimation {
                splashStarted = true
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                withAnimation {
                    splashEnded = true
                }
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
