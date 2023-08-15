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
        var isAlertPresented: Bool = false
        
        // Child
        var textEditorState = BaggleTextFeature.State(
            maxCount: 50,
            textFieldState: .inactive
        )
    }

    enum Action: Equatable {

        // Button
        case nextButtonTapped

        // View
        case moveToNextScreen

        // Alert
        case presentAlert
        case alertButtonTapped
        
        // Child
        case textEditorAction(BaggleTextFeature.Action)

        // Delegate
        case delegate(Delegate)

        enum Delegate {
            case moveToNext
            case moveToBefore
        }
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.textEditorState, action: /Action.textEditorAction) {
            BaggleTextFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

                // Button

            case .nextButtonTapped:
                if let meetingTime = state.meetingCreate.meetingTime, !meetingTime.canMeeting {
                    state.isAlertPresented = true
                    return .none
                }
                
                return .run { send in await send(.moveToNextScreen) }

            case .moveToNextScreen:
                return .run { send in await send(.delegate(.moveToNext)) }

                // Alert
            case .presentAlert:
                return .none
                
            case .alertButtonTapped:
                return .run { send in await send(.delegate(.moveToBefore))}
                // TextField

            case .textEditorAction:
                return .none

                // Delegate

            case .delegate(.moveToNext):
                return .none
                
            case .delegate(.moveToBefore):
                return .none
            }
        }
    }
}
