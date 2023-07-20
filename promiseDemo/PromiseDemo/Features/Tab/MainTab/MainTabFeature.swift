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
    }

    enum Action: Equatable {
        case selectTab(TapType)
    }

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {
            case .selectTab(let tabType):
                state.selectedTab = tabType
                return .none
            }
        }
    }
}
