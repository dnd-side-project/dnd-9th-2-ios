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
        
        var beforeMeetingEdit: MeetingEditModel
        var meetingEdit: MeetingEditModel
        
        var isLoading: Bool = false
        var editButtonDisabled: Bool = true
        
        // Alert
        var isAlertPresented: Bool = false
        var alertType: AlertMeetingEditType?
        
        
        // TextField
        var titleTextFieldState = BaggleTextFeature.State(
            maxCount: 15,
            textFieldState: .valid,
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
        
        case editModelChanged
        
        // Tap
        case backButtonTapped
        case editButtonTapped
        
        case handleResult(MeetingEditResult)
        
        // Alert
        case presentAlert(Bool)
        case alertTypeChanged(AlertMeetingEditType)
        case alertButtonTapped
        
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
        
        enum Delegate: Equatable {
            case moveToBack
            case moveToLogin
        }
    }
    
    @Dependency(\.meetingEditService) var meetingEditService

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
        
        Scope(state: \.memoTextEditorState, action: /Action.memoTextEditorAction) {
            BaggleTextFeature()
        }
        
        // MARK: - Reduce
        
        Reduce { state, action in

            switch action {
                
            case .onAppear:
                state.beforeMeetingEdit = state.meetingEdit
                
                state.titleTextFieldState.text = state.meetingEdit.title
                state.placeTextFieldState.text = state.meetingEdit.place
                state.memoTextEditorState.text = state.meetingEdit.memo
                state.meetingDateButtonState.dateButtonStatus = .valid
                state.meetingDateButtonState.timeButtonStatus = .valid
                
                return .none
                
            case .editModelChanged:
                state.editButtonDisabled = state.beforeMeetingEdit == state.meetingEdit
                return .none
                
                // MARK: - Tap
                
            case .backButtonTapped:
                return .run { send in await send(.delegate(.moveToBack)) }
                
            case .editButtonTapped:
                let beforeMeetingEdit = state.beforeMeetingEdit
                let meetingEditModel = state.meetingEdit
                
                state.isLoading = true
                return .run { send in
                    let result = await meetingEditService.editMeeting(
                        beforeMeetingEdit,
                        meetingEditModel
                    )
                    await send(.handleResult(result))
                }
                
            case .handleResult(let result):
                state.isLoading = false
                
                switch result {
                case .success:
                    return .run { send in await send(.delegate(.moveToBack))}
                case .notFound:
                    return .run { send in await send(.alertTypeChanged(.meetingNotFound))}
                case .userError:
                    return .run { send in await send(.alertTypeChanged(.userError))}
                case .networkError(let description):
                    return .run { send in await send(.alertTypeChanged(.networkError(description)))}
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
                case .failCreateMeetingEdit:
                    return .none
                case .meetingNotFound, .networkError:
                    return .run { send in await send(.delegate(.moveToBack))}
                case .userError:
                    return .run { send in await send(.delegate(.moveToLogin))}
                }
                
                // MARK: - Child

                // Text
            case .titleTextFieldAction(.textChanged(let newTitle)):
                state.meetingEdit = state.meetingEdit.update(title: newTitle)
                return .run { send in await send(.editModelChanged)}
                
            case .titleTextFieldAction:
                return .none
                
            case .placeTextFieldAction(.textChanged(let newPlace)):
                state.meetingEdit = state.meetingEdit.update(place: newPlace)
                return .run { send in await send(.editModelChanged)}
                
            case .placeTextFieldAction:
                return .none
            
            case .memoTextEditorAction(.isFocused(let isFocused)):
                state.memoTextEditorFocused = isFocused
                return .none
                
            case .memoTextEditorAction(.textChanged(let newMemo)):
                state.meetingEdit = state.meetingEdit.update(memo: newMemo)
                return .run { send in await send(.editModelChanged)}
                
            case .memoTextEditorAction:
                return .none
                
                // Date
                
            case let .dateChanged(newDate):
                state.meetingEdit = state.meetingEdit.update(date: newDate)
                return .run { send in await send(.editModelChanged)}
                
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
                    return .run { send in await send(.dateChanged(newYearMonthDate))}
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
                    return .run { send in await send(.dateChanged(newHourMinute))}
                }
                return .none
                
            case .selectTimeAction(.dismiss):
                state.meetingDateButtonState.timeButtonStatus = .valid
                return .none
                
            case .selectTimeAction:
                return .none
                
                // MARK: - Delegate
                
            case .delegate:
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
