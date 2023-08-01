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
        var description: String = "설명 글"
        // MARK: - Scope State
        @PresentationState var yearMonthDate: YearMonthDateFeature.State?
        @PresentationState var hourMinute: HourMinuteFeature.State?
    }

    enum Action: Equatable {

        case nextButtonTapped
        case yearMonthDateButtonTapped
        case hourMinuteButtonTapped

        // Child
        case yearMonthDate(PresentationAction<YearMonthDateFeature.Action>)
        case hourMinute(PresentationAction<HourMinuteFeature.Action>)
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

                // Tap

            case .nextButtonTapped:
                if state.meetingDate.canMeeting {
                    state.description = "모임 가능 시간"
                } else {
                    state.description = "모임은 2시간 이후부터 가능해요."
                }
                return .none
//                return .run { send in await send(.delegate(.moveToNext)) }

            case .yearMonthDateButtonTapped:
                state.yearMonthDate = YearMonthDateFeature.State()
                return .none

            case .hourMinuteButtonTapped:
                state.hourMinute = HourMinuteFeature.State()
                return .none

                // Child

            case .yearMonthDate(.presented(.completeButtonTapped)):
                if let yearMonthDateState = state.yearMonthDate {
                    let newDate = yearMonthDateState.baggleDatePicker.date
                    let newYearMonthDate = state.meetingDate.yearMonthDate(of: newDate)
                    state.meetingDate = newYearMonthDate
                }
                return .none

            case .yearMonthDate:
                return .none

            case .hourMinute(.presented(.completeButtonTapped)):
                if let hourMinuteState = state.hourMinute {
                    let newDate = hourMinuteState.baggleDatePicker.date
                    let newHourMinute = state.meetingDate.hourMinute(of: newDate)
                    state.meetingDate = newHourMinute
                }
                return .none

            case .hourMinute:
                return .none
                // Delegate

            case .delegate(.moveToNext):
                return .none
            }
        }
        .ifLet(\.$yearMonthDate, action: /Action.yearMonthDate) {
            YearMonthDateFeature()
        }
        .ifLet(\.$hourMinute, action: /Action.hourMinute) {
            HourMinuteFeature()
        }
    }
}
