//
//  MainTabFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import ComposableArchitecture

struct MainTabFeature: ReducerProtocol {

    struct State: Equatable {
        var selectedTab: TapType = .home

        var myPageFeature: MyPageFeature.State
    }

    enum Action: Equatable {
        case selectTab(TapType)
        case logoutMainTab(MyPageFeature.Action)
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.myPageFeature, action: /Action.logoutMainTab) {
            MyPageFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .selectTab(let tabType):
                state.selectedTab = tabType
                return .none

            case .logoutMainTab(.logoutMyPage):
                return .none

            case .logoutMainTab:
                return.none
            }
        }
    }
}
