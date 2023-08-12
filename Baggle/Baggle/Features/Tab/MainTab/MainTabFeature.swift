//
//  MainTabFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import Foundation

import ComposableArchitecture

struct MainTabFeature: ReducerProtocol {

    struct State: Equatable {
        var selectedTab: TapType = .home
        var previousTab: TapType = .home

        var myPageFeature: MyPageFeature.State

        // MARK: - Child State

        @PresentationState var createMeeting: CreateTitleFeature.State?
        @PresentationState var joinMeeting: JoinMeetingFeature.State?
    }

    enum Action: Equatable {

        // MARK: - Tap

        case selectTab(TapType)

        // MARK: - Child Action

        case createMeeting(PresentationAction<CreateTitleFeature.Action>)
        case logoutMainTab(MyPageFeature.Action)
        case enterJoinMeeting(Int)
        case changeJoinMeetingStatus(Int, JoinMeetingStatus)
        case joinMeeting(PresentationAction<JoinMeetingFeature.Action>)
        case moveToJoinMeeting(Int, JoinMeetingStatus)
    }
    
    @Dependency(\.joinMeetingService) var joinMeetingService

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
                    state.createMeeting = CreateTitleFeature.State()
                    state.previousTab = state.selectedTab
                }
                state.selectedTab = tabType
                return .none

                // MARK: - Child Action

            case .createMeeting(PresentationAction.dismiss):
                let previousTab = state.previousTab
                return .run { send in
                    await send(.selectTab(previousTab))
                }

            case .createMeeting:
                return .none

            case .logoutMainTab(.delegate(.moveToLogin)):
                state.selectedTab = .home // 로그아웃 후 재 진입시 기본 화면 홈 화면으로 설정
                return .none

            case .logoutMainTab:
                return.none
                
            case .enterJoinMeeting(let id):
                return .run { send in
                    let status = await joinMeetingService.fetchMeetingInfo(id)
                    await send(.changeJoinMeetingStatus(id, status))
                }
                
            case .changeJoinMeetingStatus(let id, let status):
                if status == .joined {
                    let delay = (state.selectedTab == .createMeeting) ? 0.2 : 0
                    let dispatchTime: DispatchTime = DispatchTime.now() + delay
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                        postObserverAction(.moveMeetingDetail, object: id)
                    }
                } else {
                    return .run { send in
                        await send(.moveToJoinMeeting(id, status))
                    }
                }
                return .none

            case .joinMeeting(PresentationAction.dismiss):
                state.selectedTab = .myPage
                return .run { send in
                    await send(.selectTab(.home))
                }

            case .joinMeeting:
                return .none

            case .moveToJoinMeeting(let id, let status):
                state.joinMeeting = JoinMeetingFeature.State(meetingId: id,
                                                             joinMeeingStatus: status)
                return .none
            }
        }
        .ifLet(\.$createMeeting, action: /Action.createMeeting) {
            CreateTitleFeature()
        }
        .ifLet(\.$joinMeeting, action: /Action.joinMeeting) {
            JoinMeetingFeature()
        }
    }
}
