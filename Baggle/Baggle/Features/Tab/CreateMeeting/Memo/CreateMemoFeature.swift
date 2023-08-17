//
//  CreateMeetingMemoFeature.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import Foundation

import ComposableArchitecture

struct CreateMemoFeature: ReducerProtocol {

    struct State: Equatable {
        
        var meetingCreate: MeetingCreateModel
        var alertType: AlertCreateMeetingType?
        
        // View
        var isAlertPresented: Bool = false
        var isLoading: Bool = false
        
        // Child
        var textEditorState = BaggleTextFeature.State(
            maxCount: 50,
            textFieldState: .inactive
        )
    }

    enum Action: Equatable {

        // Navigation Bar
        case backButtonTapped
        case closeButtonTapped
        
        // Button
        case nextButtonTapped

        // Network
        case handleStatus(MeetingCreateStatus)
        
        // Alert
        case presentAlert
        case alertButtonTapped
        
        // Child
        case textEditorAction(BaggleTextFeature.Action)

        // Delegate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case moveToNext(MeetingSuccessModel)
            case moveToBack
            case moveToHome
        }
    }
    
    @Dependency(\.meetingCreateService) private var meetingCreateService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.textEditorState, action: /Action.textEditorAction) {
            BaggleTextFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

                // Navigation Bar
                
            case .backButtonTapped:
                return .run { send in await send(.delegate(.moveToBack))}
                
            case .closeButtonTapped:
                return .run { send in await send(.delegate(.moveToHome))}
                
                // Button

            case .nextButtonTapped:
                if let meetingTime = state.meetingCreate.time, !meetingTime.canMeeting {
                    state.isAlertPresented = true
                    return .none
                }
                
                let memo = state.textEditorState.text
                state.meetingCreate =  state.meetingCreate.update(memo: memo)
                let requestModel = state.meetingCreate
                state.isLoading = true

                return .run { send in
                    let meetingCreateStatus = await meetingCreateService.create(requestModel)
                    await send(.handleStatus(meetingCreateStatus))
                }

                // Network
            case .handleStatus(let status):
                state.isLoading = false
                
                switch status {
                case .success(let meetingSuccessModel):
                    return .run { send in
                        await send(.delegate(.moveToNext(meetingSuccessModel)))
                    }
                case .duplicatedMeeting:
                    state.alertType = .duplicatedMeeting
                    return .none
                case .networkError(let description):
                    state.alertType = .networkError(description)
                    return .none
                case .userError:
                    state.alertType = .userError
                    return .none
                case .requestModelError:
                    state.alertType = .requestModelError
                    return .none
                }
                
                // Alert
            case .presentAlert:
                return .none
                
            case .alertButtonTapped:
                guard let alertType = state.alertType else {
                    return .none
                }
                state.alertType = nil
                
                switch alertType {
                case .forbiddenMeetingTime:
                    return .run { send in await send(.delegate(.moveToBack))}
                case .duplicatedMeeting:
                    return .run { send in await send(.delegate(.moveToBack))}
                case .networkError:
                    return .none
                case .userError:
                    fatalError("유저 정보 불러오기 실패")
                case .requestModelError:
                    return .run { send in await send(.delegate(.moveToHome))}
                }
                
                // TextField

            case .textEditorAction:
                return .none

                // Delegate

            case .delegate(.moveToNext):
                return .none
                
            case .delegate(.moveToBack):
                return .none
                
            case .delegate(.moveToHome):
                return .none
            }
        }
    }
}
