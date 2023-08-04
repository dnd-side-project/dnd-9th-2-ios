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

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                TabView(
                    selection: viewStore.binding(
                        get: \.selectedTab,
                        send: MainTabFeature.Action.selectTab
                    )
                ) {
                    HomeView(
                        store: Store(
                            initialState: HomeFeature.State(),
                            reducer: HomeFeature()
                        )
                    )
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
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
                ) { createMeetingTitleStore in
                    CreateTitleView(store: createMeetingTitleStore)
                }
                .fullScreenCover(
                    store: self.store.scope(
                        state: \.$joinMeeting,
                        action: { .joinMeeting($0) })
                ) { store in
                    JoinMeetingView(store: store)
                }
                .onOpenURL { url in
                    if let id = url.params()?["id"] as? String,
                       let id = Int(id) {
                        print("MainTabView - id: \(id)")

                        let delay = (viewStore.selectedTab == .createMeeting) ? 0.2 : 0
                        let dispatchTime: DispatchTime = DispatchTime.now() + delay

                        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                            // 모임 참여 여부 확인 후 분기처리
                            // 모임 참여 중 > 모임 상세로 이동
//                            postObserverAction(.moveMeetingDetail, object: id)

                            // 모임 참여 전 > 모임 정보 확인
                            viewStore.send(.moveToJoinMeeting(id))
                        }
                    }
                }
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
