//
//  MeetingEditFeature.swift
//  Baggle
//
//  Created by youtak on 2023/08/31.
//

import Foundation

import ComposableArchitecture

struct MeetingEditFeature: ReducerProtocol {

    struct State: Equatable {
        
        var meetingEdit: MeetingEdit
        
        // TextField
        var titleTextFieldState = BaggleTextFeature.State(
            maxCount: 15,
            textFieldState: .inactive,
            isFocused: false
        )
        
        var placeTextFieldState = BaggleTextFeature.State(
            maxCount: 15,
            textFieldState: .valid,
            isFocused: false
        )
        
        // Date
        var meetingDateButtonState: MeetingDateButtonFeature.State
        
        @PresentationState var selectDateState: SelectDateFeature.State?
        @PresentationState var selectTimeState: SelectTimeFeature.State?
        
        // Text Editor
        var memoTextEditorState = BaggleTextFeature.State(
            maxCount: 50,
            textFieldState: .valid
        )
        
        var memoTextEditorFocused: Bool = false
    }

    enum Action: Equatable {
        
        case onAppear
        
        // Tap
        case backButtonTapped
        case editButtonTapped
        
        // Child
        // Text
        case titleTextFieldAction(BaggleTextFeature.Action)
        case placeTextFieldAction(BaggleTextFeature.Action)
        case memoTextEditorAction(BaggleTextFeature.Action)

        // Date
        case dateChanged(Date)
        
        case meetingDateButtonAction(MeetingDateButtonFeature.Action)
        case selectDateAction(PresentationAction<SelectDateFeature.Action>)
        case selectTimeAction(PresentationAction<SelectTimeFeature.Action>)
        
        // Delegate
        case delegate(Delegate)
        
        enum Delegate {
            case moveToBack
        }
    }

    var body: some ReducerProtocolOf<Self> {
        
        // MARK: - Scope
        
        Scope(state: \.titleTextFieldState, action: /Action.titleTextFieldAction) {
            BaggleTextFeature()
        }
        
        Scope(state: \.placeTextFieldState, action: /Action.placeTextFieldAction) {
            BaggleTextFeature()
        }
        
        Scope(state: \.meetingDateButtonState, action: /Action.meetingDateButtonAction) {
            MeetingDateButtonFeature()
        }
        
//        Scope(state: \.memoTextEditorState, action: /Action.memoTextEditorAction) {
//            BaggleTextFeature()
//        }
        
        // MARK: - Reduce
        
        Reduce { state, action in

            switch action {
                
            case .onAppear:
                state.titleTextFieldState.text = state.meetingEdit.title
                state.placeTextFieldState.text = state.meetingEdit.place
                if let memo = state.meetingEdit.memo {
                    state.memoTextEditorState.text = memo
                }
                return .none
                
                // MARK: - Tap
                
            case .backButtonTapped:
                return .run { send in await send(.delegate(.moveToBack)) }
                
            case .editButtonTapped:
                print(state.meetingEdit)
                return .none
                
                
                // MARK: - Child

                // Text
            case .titleTextFieldAction:
                return .none
                
            case .placeTextFieldAction:
                return .none
            
            case .memoTextEditorAction(.isFocused(let isFocused)):
                state.memoTextEditorFocused = isFocused
                return .none
                
            case .memoTextEditorAction:
                return .none
                
                // Date
                
            case let .dateChanged(newDate):
                state.meetingEdit = state.meetingEdit.update(date: newDate)
                return .none
                
            case .meetingDateButtonAction(.selectDateButtonTapped):
                state.selectDateState = SelectDateFeature.State(date: state.meetingEdit.date)
                state.meetingDateButtonState.dateButtonStatus = .active
                return .none
                
            case .meetingDateButtonAction(.selectTimeButtonTapped):
                state.selectTimeState = SelectTimeFeature.State(time: state.meetingEdit.date)
                state.meetingDateButtonState.timeButtonStatus = .active
                return .none
                
            case .meetingDateButtonAction:
                return .none
                
                // 연, 월, 일 버튼
            case .selectDateAction(.presented(.completeButtonTapped)):
                if let yearMonthDateState = state.selectDateState {
                    let newDate = yearMonthDateState.date
                    let newYearMonthDate = state.meetingEdit.date.yearMonthDate(of: newDate)
                    state.meetingEdit = state.meetingEdit.update(date: newYearMonthDate)
                }
                return .none
                
            case .selectDateAction(.dismiss):
                state.meetingDateButtonState.dateButtonStatus = .valid
                return .none
                
            case .selectDateAction:
                return .none
                
            case .selectTimeAction(.presented(.completeButtonTapped)):
                if let hourMinuteState = state.selectTimeState {
                    let newDate = hourMinuteState.time
                    let newHourMinute = state.meetingEdit.date.hourMinute(of: newDate)
                    state.meetingEdit = state.meetingEdit.update(date: newHourMinute)
                }
                return .none
                
            case .selectTimeAction(.dismiss):
                state.meetingDateButtonState.timeButtonStatus = .valid
                return .none
                
            case .selectTimeAction:
                return .none
                
                // MARK: - Delegate
            case .delegate(.moveToBack):
                return .none
            }
        }
        .ifLet(\.$selectDateState, action: /Action.selectDateAction) {
            SelectDateFeature()
        }
        .ifLet(\.$selectTimeState, action: /Action.selectTimeAction) {
            SelectTimeFeature()
        }
    }
}
