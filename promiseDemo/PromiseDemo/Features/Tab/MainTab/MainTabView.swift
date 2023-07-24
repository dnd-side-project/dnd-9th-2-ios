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
                HomeView()
                    .tabItem {
                        Button {
                        } label: {
                            Image(systemName: "house")
                            Text("홈")
                        }
                    }
                    .tag(TapType.home)

                ZStack {
                }
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("모임 생성")
                }
                .tag(TapType.createMeeting)

                MyPageView(
                    store: self.store.scope(
                        state: \.myPageFeature,
                        action: MainTabFeature.Action.logoutMainTab
                    )
                )
                .tabItem {
                    Image(systemName: "person")
                    Text("마이페이지")
                }
                .tag(TapType.myPage)
            }
            .fullScreenCover(
                store: self.store.scope(
                    state: \.$createMeeting,
                    action: { .createMeeting($0) })
            ) { createMeetingStore in
                CreateMeetingView(store: createMeetingStore)
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(
            store: Store(
                initialState: MainTabFeature.State(
                    myPageFeature: MyPageFeature.State()
                ),
                reducer: MainTabFeature()
            )
        )
    }
}
