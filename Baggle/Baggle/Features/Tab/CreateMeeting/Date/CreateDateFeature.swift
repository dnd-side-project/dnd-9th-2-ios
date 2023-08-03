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

        // 날짜 버튼
        var dateButtonBeforeStatus: DateInputStatus = .inactive
        var timeButtonBeforeStatus: DateInputStatus = .inactive

        var dateButtonStatus: DateInputStatus = .inactive
        var timeButtonStatus: DateInputStatus = .inactive

        // MARK: - Scope State
        @PresentationState var selectDateState: SelectDateFeature.State?
        @PresentationState var selectTimeState: SelectTimeFeature.State?
    }

    enum Action: Equatable {

        // Tap
        case nextButtonTapped
        case selectDateButtonTapped
        case selectTimeButtonTapped

        case statusChanged

        // Child
        case selectDateAction(PresentationAction<SelectDateFeature.Action>)
        case selectTimeAction(PresentationAction<SelectTimeFeature.Action>)
        // Delegate
        case delegate(Delegate)

        enum Delegate {
            case moveToNext
        }
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

                // MARK: - Tap

            case .nextButtonTapped:
                if state.meetingDate.canMeeting {
                    return .run { send in await send(.delegate(.moveToNext)) }
                } else {
                    state.errorMessage = "모임은 2시간 이후부터 가능해요."
                    state.dateButtonStatus = .invalid
                    state.timeButtonStatus = .invalid
                }
                return .none

            case .selectDateButtonTapped:
                state.selectDateState = SelectDateFeature.State(date: state.meetingDate)
                state.dateButtonStatus = .active

                // 유효성 검사 실패 이후 터치 시, 버튼 2개다 경고, 에러메시지를 없애주기 위함
                if state.timeButtonStatus == .invalid {
                    state.timeButtonStatus = .valid
                    state.errorMessage = nil
                }
                return .none

            case .selectTimeButtonTapped:
                state.selectTimeState = SelectTimeFeature.State(time: state.meetingDate)
                state.timeButtonStatus = .active

                // 유효성 검사 실패 이후 터치 시, 버튼 2개다 경고를 없애주기 위함
                if state.dateButtonStatus == .invalid {
                    state.dateButtonStatus = .valid
                    state.errorMessage = nil
                }
                return .none

            case .statusChanged:
                if state.dateButtonStatus == .inactive || state.timeButtonStatus == .inactive {
                    state.buttonDisabled = true
                } else {
                    state.buttonDisabled = false
                }
                return .none

                // MARK: - Child

                // 연, 월, 일 버튼
            case .selectDateAction(.presented(.completeButtonTapped)):
                if let yearMonthDateState = state.selectDateState {
                    let newDate = yearMonthDateState.date
                    let newYearMonthDate = state.meetingDate.yearMonthDate(of: newDate)
                    state.meetingDate = newYearMonthDate
                }
                state.dateButtonBeforeStatus = .valid
                return .run { send in await send(.statusChanged) }

            case .selectDateAction(.dismiss):
                state.dateButtonStatus = state.dateButtonBeforeStatus
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
                state.timeButtonBeforeStatus = .valid
                return .run { send in await send(.statusChanged) }

            case .selectTimeAction(.dismiss):
                state.timeButtonStatus = state.timeButtonBeforeStatus
                return .none

            case .selectTimeAction:
                return .none

                // MARK: - Delegate

            case .delegate(.moveToNext):
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
