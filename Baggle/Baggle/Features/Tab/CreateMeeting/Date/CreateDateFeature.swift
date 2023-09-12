//
//  CreateMeetingDateFeature.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

struct CreateDateFeature: ReducerProtocol {
    
    struct State: Equatable {
        
        var meetingDate: Date = Date.now().meetingStartTime()
        var buttonDisabled: Bool = true
        var errorMessage: String?
        
        // MARK: - Scope State
        var meetingDateButtonState: MeetingDateButtonFeature.State

        @PresentationState var selectDateState: SelectDateFeature.State?
        @PresentationState var selectTimeState: SelectTimeFeature.State?
    }
    
    enum Action: Equatable {
        
        case onAppear
        
        // Navigation Bar
        case backButtonTapped
        case closeButtonTapped
        
        // Tap
        case nextButtonTapped
        
        // State
        case statusChanged
        case dateChanged(Date)
        
        // Child
        case meetingDateButtonAction(MeetingDateButtonFeature.Action)
        
        case selectDateAction(PresentationAction<SelectDateFeature.Action>)
        case selectTimeAction(PresentationAction<SelectTimeFeature.Action>)
        // Delegate
        
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case moveToNext(Date)
            case moveToBack
            case moveToHome
        }
    }
    
    var body: some ReducerProtocolOf<Self> {
        
        // MARK: - Scope
        Scope(state: \.meetingDateButtonState, action: /Action.meetingDateButtonAction) {
            MeetingDateButtonFeature()
        }
        
        // MARK: - Reduce
        
        Reduce { state, action in
            
            switch action {
                
            case .onAppear:
                // 조건문 없으면 메모 화면에서 되돌아 왔을 때, Date가 선택되어 있어도 선택 창이 뜸
                if state.meetingDateButtonState.dateButtonStatus == .inactive {
                    return .run { send in
                        await send(.meetingDateButtonAction(.selectDateButtonTapped))
                    }
                }
                return .none
                
                // MARK: - Navigation Bar
            case .backButtonTapped:
                return .run { send in await send(.delegate(.moveToBack))}
                
            case .closeButtonTapped:
                return .run { send in await send(.delegate(.moveToHome))}
                
                // MARK: - Tap
                
            case .nextButtonTapped:
                if state.meetingDate.canMeeting {
                    let meetingTime = state.meetingDate
                    return .run { send in await send(.delegate(.moveToNext(meetingTime))) }
                } else {
                    state.errorMessage = "모임은 2시간 이후부터 가능해요."
                    state.meetingDateButtonState.dateButtonStatus = .invalid
                    state.meetingDateButtonState.timeButtonStatus = .invalid
                }
                return .none
                
                // MARK: - State
                
            case .statusChanged:
                if state.meetingDateButtonState.dateButtonStatus == .inactive
                    || state.meetingDateButtonState.timeButtonStatus == .inactive {
                    state.buttonDisabled = true
                } else {
                    state.buttonDisabled = false
                }
                return .none
                
            case .dateChanged(let newDate):
                state.meetingDate = newDate
                return .none
                
                
                // MARK: - Child
                
                // 버튼 View
            case .meetingDateButtonAction(.selectDateButtonTapped):
                state.selectDateState = SelectDateFeature.State(date: state.meetingDate)
                state.meetingDateButtonState.dateButtonStatus = .active
                
                // 유효성 검사 실패 이후 터치 시, 버튼 2개다 경고, 에러메시지를 없애주기 위함
                if state.meetingDateButtonState.timeButtonStatus == .invalid {
                    state.meetingDateButtonState.timeButtonStatus = .valid
                    state.errorMessage = nil
                }
                return .none
                
            case .meetingDateButtonAction(.selectTimeButtonTapped):
                state.selectTimeState = SelectTimeFeature.State(time: state.meetingDate)
                state.meetingDateButtonState.timeButtonStatus = .active
                
                // 유효성 검사 실패 이후 터치 시, 버튼 2개다 경고를 없애주기 위함
                if state.meetingDateButtonState.dateButtonStatus == .invalid {
                    state.meetingDateButtonState.dateButtonStatus = .valid
                    state.errorMessage = nil
                }
                return .none
                
            case .meetingDateButtonAction:
                return .none
                
                // 연, 월, 일 버튼
            case .selectDateAction(.presented(.completeButtonTapped)):
                if let yearMonthDateState = state.selectDateState {
                    let newDate = yearMonthDateState.date
                    let newYearMonthDate = state.meetingDate.yearMonthDate(of: newDate)
                    state.meetingDate = newYearMonthDate
                }
                state.meetingDateButtonState.dateButtonBeforeStatus = .valid
                return .run { send in
                    await send(.statusChanged)
                }
                
            case .selectDateAction(.dismiss):
                // swiftlint:disable:next line_length
                state.meetingDateButtonState.dateButtonStatus = state.meetingDateButtonState.dateButtonBeforeStatus
                if state.meetingDateButtonState.timeButtonStatus == .inactive {
                    return .run { send in
                        try await Task.sleep(seconds: 0.3)
                        await send(.meetingDateButtonAction( .selectTimeButtonTapped))
                    }
                }
                return .none
                
            case .selectDateAction:
                return .none
                
                // 시간, 분 버튼
                
            case .selectTimeAction(.presented(.completeButtonTapped)):
                if let hourMinuteState = state.selectTimeState {
                    let newDate = hourMinuteState.time
                    let newHourMinute = state.meetingDate.hourMinute(of: newDate)
                    state.meetingDate = newHourMinute
                }
                state.meetingDateButtonState.timeButtonBeforeStatus = .valid
                return .run { send in await send(.statusChanged) }
                
            case .selectTimeAction(.dismiss):
                // swiftlint:disable:next line_length
                state.meetingDateButtonState.timeButtonStatus = state.meetingDateButtonState.timeButtonBeforeStatus
                return .none
                
            case .selectTimeAction:
                return .none
                
                // MARK: - Delegate
                
            case .delegate(.moveToNext):
                return .none
                
            case .delegate(.moveToBack):
                return .none
                
            case .delegate(.moveToHome):
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
