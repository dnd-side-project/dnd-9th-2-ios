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
        var isLoading: Bool = false
        
        // MARK: - Child State
        
        var homeFeature: HomeFeature.State
        var myPageFeature: MyPageFeature.State
        
        @PresentationState var createMeeting: CreateTitleFeature.State?
        @PresentationState var joinMeeting: JoinMeetingFeature.State?
        
        // MARK: - Alert
        
        var isAlertPresented: Bool = false
        var alertType: AlertMainTabType?
        
        // MARK: - Navigation Stack
        
        var path = StackState<Child.State>()
    }

    enum Action: Equatable {

        // MARK: - Tap

        case selectTab(TapType)

        // MARK: - Alert
        
        case presentAlert(Bool)
        case alertTypeChanged(AlertMainTabType)
        case alertButtonTapped
        
        // MARK: - Child Action
        
        case homeAction(HomeFeature.Action)
        case myPageAction(MyPageFeature.Action)
        
        case createMeeting(PresentationAction<CreateTitleFeature.Action>)
        case enterJoinMeeting(Int)
        case changeJoinMeetingResult(Int, JoinMeetingResult)
        case joinMeeting(PresentationAction<JoinMeetingFeature.Action>)
        case moveToJoinMeeting(Int, JoinMeetingResult)
        
        case withdrawResult(WithdrawServiceResult)
        case logoutResult(LogoutServiceResult)
        
        // MARK: - Navigation
        case path(StackAction<Child.State, Child.Action>)
        
        // MARK: - Delegate
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case moveToLogin
        }
    }
    
    struct Child: ReducerProtocol {

        enum State: Equatable {
            case meetingDetail(MeetingDetailFeature.State)
            case meetingEdit(MeetingEditFeature.State)
        }

        enum Action: Equatable {
            case meetingDetail(MeetingDetailFeature.Action)
            case meetingEdit(MeetingEditFeature.Action)
        }

        var body: some ReducerProtocolOf<Self> {
            Scope(state: /State.meetingDetail, action: /Action.meetingDetail) {
                MeetingDetailFeature()
            }
            
            Scope(state: /State.meetingEdit, action: /Action.meetingEdit) {
                MeetingEditFeature()
            }
        }
    }
    
    @Dependency(\.joinMeetingService) var joinMeetingService
    @Dependency(\.withdrawService) var withdrawService
    @Dependency(\.logoutService) var logoutService

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

                // MARK: - Alert
                
            case .presentAlert(let isPresented):
                if !isPresented {
                    state.alertType = nil
                }
                state.isAlertPresented = isPresented
                return .none
            
            case .alertTypeChanged(let alertType):
                state.alertType = alertType
                state.isAlertPresented = true
                return .none
            
            case .alertButtonTapped:
                guard let alertType = state.alertType else {
                    return .none
                }
                state.alertType = nil
                
                switch alertType {
                case .logout:
                    return .run { send in
                        let result = await logoutService.logout()
                        await send(.logoutResult(result))
                    }
                case .withdraw:
                    return .run { send in
                        let result = await withdrawService.withdraw()
                        await send(.withdrawResult(result))
                    }
                case .networkError:
                    return .none
                case .userError:
                    return .run { send in await send(.delegate(.moveToLogin)) }
                }
                
                // MARK: - Child Action

                // 홈
            case .homeAction(.delegate(.moveToLogin)):
                return .run { send in await send(.delegate(.moveToLogin))}
                
            case let .homeAction(.delegate(.moveToMeetingDetail(id))):
                state.path.append(
                    .meetingDetail(
                        MeetingDetailFeature.State(meetingId: id)
                    )
                )
                return .none
                
            case .homeAction(.delegate(.alert(let alertHomeType))):
                switch alertHomeType {
                case .userError:
                    return .run { send in await send(.alertTypeChanged(.userError))}
                }
                
                
            case .homeAction:
                return .none
                
                // MARK: - 모임 생성
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

                // MARK: - 마이페이지
                
            case .myPageAction(.delegate(.moveToLogin)):
                return .run { send in await send(.delegate(.moveToLogin))}
                
            case .myPageAction(.delegate(.presentLogout)):
                return .run { send in await send(.alertTypeChanged(.logout))}
                
            case .myPageAction(.delegate(.presentWithdraw)):
                return .run { send in await send(.alertTypeChanged(.withdraw))}

            case .myPageAction:
                return.none
                
            case .logoutResult(let result):
                state.isLoading = false
                switch result {
                case .success:
                    return .run { send in await send(.delegate(.moveToLogin))}
                case .networkError(let description):
                    return .run { send in await send(.alertTypeChanged(.networkError(description)))}
                case .userError:
                    return .run { send in await send(.alertTypeChanged(.userError))}
                }
                
            case let .withdrawResult(status):
                state.isLoading = false
                switch status {
                case .success:
                    print("성공")
                    return .run { send in await send(.delegate(.moveToLogin)) }
                case .networkError(let description):
                    return .run { send in await send(.alertTypeChanged(.networkError(description)))}
                case .userError:
                    return .run { send in await send(.alertTypeChanged(.userError)) }
                }
                
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
                
            case .joinMeeting(PresentationAction.presented(.delegate(.moveToLogin))):
                return .run { send in await send(.delegate(.moveToLogin))}
                
            case .joinMeeting:
                return .none

            case .moveToJoinMeeting(let id, let status):
                state.joinMeeting = JoinMeetingFeature.State(
                    meetingId: id,
                    joinMeetingStatus: status
                )
                return .none
                
                // MARK: - Navigation
                
                // 모임 상세
            case let .path(.element(id: id, action: .meetingDetail(.delegate(.onDisappear)))):
                state.path.pop(from: id)
                return .none
            
            case let .path(
                .element(
                    id: id,
                    action: .meetingDetail(.delegate(.moveToEdit(newMeetingEdit)))
                )
            ):
                _ = id
                state.path.append(
                    .meetingEdit(
                        MeetingEditFeature.State(
                            meetingEdit: newMeetingEdit,
                            meetingDateButtonState: MeetingDateButtonFeature.State()
                        )
                    )
                )
                return .none
                // 삭제시 home refresh
                // 유저 에러시 로그인으로 
                
            case let .path(.element(id: id, action: .meetingEdit(.delegate(.moveToBack)))):
                state.path.pop(from: id)
                return .none
                
            case .path:
                return .none
                
                // MARK: - Delegate
                
            case .delegate(.moveToLogin):
                state.selectedTab = .home // 로그아웃 후 재 진입시 기본 화면 홈 화면으로 설정
                return .none
                
            case .delegate:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Child()
        }
        .ifLet(\.$createMeeting, action: /Action.createMeeting) {
            CreateTitleFeature()
        }
        .ifLet(\.$joinMeeting, action: /Action.joinMeeting) {
            JoinMeetingFeature()
        }
    }
}
