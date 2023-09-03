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

        // MARK: - Child State
        var homeFeature: HomeFeature.State
        var myPageFeature: MyPageFeature.State
        
        @PresentationState var createMeeting: CreateTitleFeature.State?
        @PresentationState var joinMeeting: JoinMeetingFeature.State?
        
        // MARK: - Alert
        var alertType: AlertMainTabType?
        
        var isLoading: Bool = false
    }

    enum Action: Equatable {

        // MARK: - Tap

        case selectTab(TapType)

        // MARK: - Child Action
        case homeAction(HomeFeature.Action)
        case myPageAction(MyPageFeature.Action)
        
        case createMeeting(PresentationAction<CreateTitleFeature.Action>)
        case enterJoinMeeting(Int)
        case changeJoinMeetingResult(Int, JoinMeetingResult)
        case joinMeeting(PresentationAction<JoinMeetingFeature.Action>)
        case moveToJoinMeeting(Int, JoinMeetingResult)
        
        // MARK: - Alert
        case presentAlert(Bool)
        case alertButtonTapped
        
        case withdrawResult(WithdrawServiceResult)
        
        // MARK: - Delegate
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case moveToLogin
        }
    }
    
    @Dependency(\.joinMeetingService) var joinMeetingService
    @Dependency(\.withdrawService) var withdrawService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope
        Scope(state: \.homeFeature, action: /Action.homeAction) {
            HomeFeature()
        }

        Scope(state: \.myPageFeature, action: /Action.myPageAction) {
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

                // 홈
            case .homeAction(.delegate(.moveToLogin)):
                return .run { send in await send(.delegate(.moveToLogin))}
                
            case .homeAction:
                return .none
                
                // 모임 생성
            case .createMeeting(PresentationAction.dismiss):
                let previousTab = state.previousTab
                return .run { send in
                    await send(.selectTab(previousTab))
                }
                
            case .createMeeting(.presented(.delegate(.createSuccess))):
                return .run { send in
                    await send(.homeAction(.refreshMeetingList))
                }
                
            case .createMeeting(.presented(.delegate(.moveToLogin))):
                return .run { send in await send(.delegate(.moveToLogin))}

            case .createMeeting:
                return .none

                // 마이페이지
                
            case .myPageAction(.delegate(.moveToLogin)):
                return .run { send in await send(.delegate(.moveToLogin))}
                
            case .myPageAction(.delegate(.presentLogout)):
                state.alertType = .logout
                return .none
                
            case .myPageAction(.delegate(.presentWithdraw)):
                state.alertType = .withdraw
                return .none

            case .myPageAction:
                return.none
                
            case .presentAlert(let isPresented):
                if !isPresented {
                    state.alertType = nil
                }
                return .none
                
            case .alertButtonTapped:
                guard let alertType = state.alertType else { return .none }
                state.alertType = nil
                
                // 서버 통신
                switch alertType {
                case .logout:
                    // 로그아웃 통신 -> 성공 -> userdefault 삭제
                    UserManager.shared.delete()
                    return .run { send in await send(.delegate(.moveToLogin))}
                case .withdraw:
                    // 회원가입 통신 -> 성공 -> userdefault 삭제
                    state.isLoading = true
                    return .run { send in
                        let widthdrawStatus = await withdrawService.withdraw()
                        await send(.withdrawResult(widthdrawStatus))
                    }
                }
                
            case let .withdrawResult(status):
                state.isLoading = false
                switch status {
                case .success:
                    print("성공")
                    return .run { send in await send(.delegate(.moveToLogin)) }
                case let .fail(apiError):
                    print("API Error \(apiError)")
                case .keyChainError:
                    print("키체인 에러")
                }
                return .none
                
            case .enterJoinMeeting(let id):
                return .run { send in
                    let result = await joinMeetingService.fetchMeetingInfo(id)
                    await send(.changeJoinMeetingResult(id, result))
                }
                
            case .changeJoinMeetingResult(let id, let result):
                if result == .joined {
                    let delay = (state.selectedTab == .createMeeting) ? 0.2 : 0
                    let dispatchTime: DispatchTime = DispatchTime.now() + delay
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                        postObserverAction(.moveMeetingDetail, object: id)
                    }
                } else {
                    return .run { send in
                        await send(.moveToJoinMeeting(id, result))
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
                                                             joinMeetingStatus: status)
                return .none
                
                // MARK: - Delegate
                
            case .delegate(.moveToLogin):
                state.selectedTab = .home // 로그아웃 후 재 진입시 기본 화면 홈 화면으로 설정
                return .none
                
            case .delegate:
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
