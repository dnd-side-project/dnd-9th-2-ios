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
    
    init(store: StoreOf<MainTabFeature>) {
        self.store = store
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.gray4)
    }
    
    var body: some View {
        
        NavigationStackStore(self.store.scope(
            state: \.path,
            action: { .path($0)})
        )  {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                TabView(
                    selection: viewStore.binding(
                        get: \.selectedTab,
                        send: MainTabFeature.Action.selectTab
                    )
                ) {
                    HomeView(
                        store: self.store.scope(
                            state: \.homeFeature,
                            action: MainTabFeature.Action.homeAction
                        )
                    )
                    .tabItem {
                        Image.Icon.homeFill
                            .renderingMode(.template)
                        Text("홈")
                    }
                    .tag(TapType.home)
                    
                    ZStack {
                    }
                    .tabItem {
                        Image.Icon.plusFill
                            .renderingMode(.template)
                        Text("모임 생성")
                    }
                    .tag(TapType.createMeeting)
                    
                    MyPageView(
                        store: self.store.scope(
                            state: \.myPageFeature,
                            action: MainTabFeature.Action.myPageAction
                        )
                    )
                    .tabItem {
                        Image.Icon.myPageFill
                            .renderingMode(.template)
                        Text("마이페이지")
                    }
                    .tag(TapType.myPage)
                }
                .tint(.black)
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
                .onReceive(
                    NotificationCenter.default.publisher(for: .joinMeeting),
                    perform: { noti in
                        if let id = noti.object as? Int {
                            viewStore.send(.enterJoinMeeting(id))
                        }
                    }
                )
            }
        } destination: { pathState in
            switch pathState {
            case .meetingDetail:
                CaseLet(
                    /MainTabFeature.Child.State.meetingDetail,
                    action: MainTabFeature.Child.Action.meetingDetail
                ) { store in
                    MeetingDetailView(store: store)
                }
            case .meetingEdit:
                CaseLet(
                    /MainTabFeature.Child.State.meetingEdit,
                    action: MainTabFeature.Child.Action.meetingEdit
                ) { store in
                    MeetingEditView(store: store)
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
                    homeFeature: HomeFeature.State(),
                    myPageFeature: MyPageFeature.State()
                ),
                reducer: MainTabFeature()
            )
        )
    }
}
