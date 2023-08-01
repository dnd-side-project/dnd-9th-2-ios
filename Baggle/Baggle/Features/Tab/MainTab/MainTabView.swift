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
                .onOpenURL { url in
                    if let id = url.params()?["id"] as? String,
                       let id = Int(id) {
                        print("MainTabView - id: \(id)")
                        // 모임 참여 여부 서버 통신
                        // 모임 참여 중 > 모임 상세로 이동
//                        postObserverAction(.moveMeetingDetail)

                        // 모임 참여 전 > 모임 정보 확인
                        viewStore.send(.moveToJoinMeeting(id))
                    }
                }
                .fullScreenCover(
                    isPresented: Binding(
                        get: { viewStore.joinMeetingId != nil },
                        set: { _ in
                            viewStore.send(.moveToJoinMeeting(viewStore.joinMeetingId ?? 0)) })
                ) {
                    JoinMeetingView(store: Store(
                        initialState: JoinMeetingFeature.State(),
                        reducer: JoinMeetingFeature(meetingId: viewStore.joinMeetingId ?? 0))
                    )
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
