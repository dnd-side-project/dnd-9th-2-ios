//
//  MainTabView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

import ComposableArchitecture

struct MainTabView: View {

    let store: StoreOf<MainTabFeature>

    var body: some View {

        WithViewStore(self.store) { viewStore in

            TabView(
                selection: viewStore.binding(
                    get: \.selectedTab,
                    send: MainTabFeature.Action.selectTab
                )
            ) {
                    Text("Hello")
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
                    }
                    .tag(TapType.home)

                    Text("마이페이지")
                    .tabItem {
                        Image(systemName: "person")
                        Text("마이페이지")
                    }
                    .tag(TapType.myPage)
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(
            store: Store(
                initialState: MainTabFeature.State(),
                reducer: MainTabFeature()
            )
        )
    }
}
