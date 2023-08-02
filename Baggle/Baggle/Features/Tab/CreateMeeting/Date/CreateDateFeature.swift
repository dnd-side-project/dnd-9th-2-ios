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
        var yearMonthDateBeforeStatus: DateButtonStatus = .inactive
        var hourMinuteBeforeStatue: DateButtonStatus = .inactive

        var yearMonthDateStatus: DateButtonStatus = .inactive
        var hourMinuteStatus: DateButtonStatus = .inactive

        // MARK: - Scope State
        @PresentationState var yearMonthDate: SelectDateFeature.State?
        @PresentationState var hourMinute: SelectTimeFeature.State?
    }

    enum Action: Equatable {

        // Tap
        case nextButtonTapped
        case yearMonthDateButtonTapped
        case hourMinuteButtonTapped

        case statusChanged

        // Child
        case yearMonthDate(PresentationAction<SelectDateFeature.Action>)
        case hourMinute(PresentationAction<SelectTimeFeature.Action>)
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
                    state.yearMonthDateStatus = .invalid
                    state.hourMinuteStatus = .invalid
                }
                return .none

            case .yearMonthDateButtonTapped:
                state.yearMonthDate = SelectDateFeature.State(date: state.meetingDate)
                state.yearMonthDateStatus = .active

                // 유효성 검사 실패 이후 터치 시, 버튼 2개다 경고, 에러메시지를 없애주기 위함
                if state.hourMinuteStatus == .invalid {
                    state.hourMinuteStatus = .valid
                    state.errorMessage = nil
                }
                return .none

            case .hourMinuteButtonTapped:
                state.hourMinute = SelectTimeFeature.State(date: state.meetingDate)
                state.hourMinuteStatus = .active

                // 유효성 검사 실패 이후 터치 시, 버튼 2개다 경고를 없애주기 위함
                if state.yearMonthDateStatus == .invalid {
                    state.yearMonthDateStatus = .valid
                    state.errorMessage = nil
                }
                return .none

            case .statusChanged:
                if state.yearMonthDateStatus == .inactive || state.hourMinuteStatus == .inactive {
                    state.buttonDisabled = true
                } else {
                    state.buttonDisabled = false
                }
                return .none

                // MARK: - Child

                // 연, 월, 일 버튼
            case .yearMonthDate(.presented(.completeButtonTapped)):
                if let yearMonthDateState = state.yearMonthDate {
                    let newDate = yearMonthDateState.date
                    let newYearMonthDate = state.meetingDate.yearMonthDate(of: newDate)
                    state.meetingDate = newYearMonthDate
                }
                state.yearMonthDateBeforeStatus = .valid
                return .run { send in await send(.statusChanged) }

            case .yearMonthDate(.dismiss):
                state.yearMonthDateStatus = state.yearMonthDateBeforeStatus
                return .none

            case .yearMonthDate:
                return .none

                // 시간, 분 버튼

            case .hourMinute(.presented(.completeButtonTapped)):
                if let hourMinuteState = state.hourMinute {
                    let newDate = hourMinuteState.date
                    let newHourMinute = state.meetingDate.hourMinute(of: newDate)
                    state.meetingDate = newHourMinute
                }
                state.hourMinuteBeforeStatue = .valid
                return .run { send in await send(.statusChanged) }

            case .hourMinute(.dismiss):
                state.hourMinuteStatus = state.hourMinuteBeforeStatue
                return .none

            case .hourMinute:
                return .none

                // MARK: - Delegate

            case .delegate(.moveToNext):
                return .none
            }
        }
        .ifLet(\.$yearMonthDate, action: /Action.yearMonthDate) {
            SelectDateFeature()
        }
        .ifLet(\.$hourMinute, action: /Action.hourMinute) {
            SelectTimeFeature()
        }
    }
}
