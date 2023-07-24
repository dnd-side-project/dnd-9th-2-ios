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

        // MARK: - Child State

        @PresentationState var createMeeting: CreateMeetingFeature.State?
    }

    enum Action: Equatable {

        // MARK: - Tap

        case selectTab(TapType)

        // MARK: - Child Action

        case createMeeting(PresentationAction<CreateMeetingFeature.Action>)
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

                // MARK: - Tap

            case .selectTab(let tabType):
                if tabType == .createMeeting {
                    state.createMeeting = CreateMeetingFeature.State()
                } else {
                    state.selectedTab = tabType
                }
                return .none

                // MARK: - Child Action

            case .createMeeting:
                return .none

            case .logoutMainTab(.logoutMyPage):
                state.selectedTab = .home // 로그아웃 후 재 진입시 기본 화면 홈 화면으로 설정
                return .none

            case .logoutMainTab:
                return.none
            }
        }
        .ifLet(\.$createMeeting, action: /Action.createMeeting) {
            CreateMeetingFeature()
        }
    }
}
