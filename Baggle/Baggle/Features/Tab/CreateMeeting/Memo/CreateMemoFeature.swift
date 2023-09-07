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
        
        // MARK: - Model
        
        var meetingCreate: MeetingCreateModel

        // MARK: - View
        
        var isLoading: Bool = false

        // MARK: - Alert
        
        var isAlertPresented: Bool = false
        var alertType: AlertCreateMeetingType?
        
        // MARK: - Child
        var textEditorState = BaggleTextFeature.State(
            maxCount: 50,
            textFieldState: .inactive
        )
    }

    enum Action: Equatable {

        // MARK: - Navigation Bar
        case backButtonTapped
        case closeButtonTapped
        
        // MARK: - Button
        case nextButtonTapped

        // MARK: - Network
        case handleResult(MeetingCreateResult)
        
        // MARK: - Alert
        case presentAlert(Bool)
        case alertTypeChanged(AlertCreateMeetingType)
        case alertButtonTapped
        
        // MARK: - Child
        case textEditorAction(BaggleTextFeature.Action)

        // MARK: - Delegate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case moveToNext(MeetingSuccessModel)
            case moveToBack
            case moveToHome
            case moveToLogin
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

                // MARK: - Navigation Bar
                
            case .backButtonTapped:
                return .run { send in await send(.delegate(.moveToBack))}
                
            case .closeButtonTapped:
                
                return .run { send in await send(.delegate(.moveToHome))}
                
                // MARK: - Button

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
                    let result = await meetingCreateService.create(requestModel)
                    await send(.handleResult(result))
                }

                // MARK: - Network
                
            case .handleResult(let result):
                state.isLoading = false
                
                switch result {
                case .success(let meetingSuccessModel):
                    return .run { send in
                        await send(.delegate(.moveToNext(meetingSuccessModel)))
                    }
                case .duplicatedMeeting:
                    return .run { send in await send(.alertTypeChanged(.duplicatedMeeting))}
                case .limitMeetingCount:
                    return .run { send in await send(.alertTypeChanged(.limitMeetingCount))}
                case .networkError(let description):
                    return .run { send in await send(.alertTypeChanged(.networkError(description)))}
                case .userError:
                    return .run { send in await send(.alertTypeChanged(.userError))}
                case .requestModelError:
                    return .run { send in await send(.alertTypeChanged(.requestModelError))}
                }
                
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
                case .forbiddenMeetingTime:
                    return .run { send in await send(.delegate(.moveToBack))}
                case .duplicatedMeeting:
                    return .run { send in await send(.delegate(.moveToBack))}
                case .limitMeetingCount:
                    return .run { send in await send(.delegate(.moveToHome))}
                case .networkError:
                    return .none
                case .userError:
                    return .run { send in await send(.delegate(.moveToLogin))}
                case .requestModelError:
                    return .run { send in await send(.delegate(.moveToHome))}
                }

                // MARK: - TextField

            case .textEditorAction:
                return .none

                // Delegate

            case .delegate(.moveToNext):
                return .none
                
            case .delegate(.moveToBack):
                return .none
                
            case .delegate(.moveToHome):
                return .none
                
            case .delegate(.moveToLogin):
                return .none
            }
        }
    }
}
