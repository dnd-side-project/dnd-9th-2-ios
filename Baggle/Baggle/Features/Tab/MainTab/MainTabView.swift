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

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                NavigationStack {
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
                
                if let alertType = viewStore.alertType {
                    if alertType.buttonType == .one {
                        BaggleAlertOneButton(
                            isPresented: Binding(
                                get: { viewStore.alertType != nil },
                                set: { viewStore.send(.presentAlert($0)) }
                            ),
                            title: alertType.title,
                            description: alertType.description,
                            buttonTitle: alertType.buttonTitle
                        ) {
                            viewStore.send(.alertButtonTapped)
                        }
                    } else if alertType.buttonType == .two {
                        BaggleAlertTwoButton(
                            isPresented: Binding(
                                get: { viewStore.alertType != nil },
                                set: { viewStore.send(.presentAlert($0)) }
                            ),
                            title: alertType.title,
                            description: alertType.description,
                            alertType: alertType.rightButtonType,
                            rightButtonTitle: alertType.buttonTitle,
                            leftButtonAction: nil
                        ) {
                            viewStore.send(.alertButtonTapped)
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
                    homeFeature: HomeFeature.State(),
                    myPageFeature: MyPageFeature.State()
                ),
                reducer: MainTabFeature()
            )
        )
    }
}
