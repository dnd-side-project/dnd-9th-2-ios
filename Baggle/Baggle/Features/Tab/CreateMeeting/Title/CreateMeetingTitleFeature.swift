//
//  CreateMeetingFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/24.
//

import Foundation

import ComposableArchitecture

struct CreateMeetingTitleFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State

        var path = StackState<Child.State>()
    }

    enum Action: Equatable {

        // MARK: - Tap
        case cancelButtonTapped
        case nextButtonTapped

        // MARK: - Scope Action

        case path(StackAction<Child.State, Child.Action>)
    }

    struct Child: ReducerProtocol {

        enum State: Equatable {
            case meetingPlace(CreateMeetingPlaceFeature.State)
            case meetingDate(CreateMeetingDateFeature.State)
            case meetingMemo(CreateMeetingMemoFeature.State)
            case createSuccess(CreateMeetingSuccessFeature.State)
        }

        enum Action: Equatable {
            case meetingPlace(CreateMeetingPlaceFeature.Action)
            case meetingDate(CreateMeetingDateFeature.Action)
            case meetingMemo(CreateMeetingMemoFeature.Action)
            case createSuccess(CreateMeetingSuccessFeature.Action)
        }

        var body: some ReducerProtocolOf<Self> {
            Scope(state: /State.meetingPlace, action: /Action.meetingPlace) {
                CreateMeetingPlaceFeature()
            }
            Scope(state: /State.meetingDate, action: /Action.meetingDate) {
                CreateMeetingDateFeature()
            }
            Scope(state: /State.meetingMemo, action: /Action.meetingMemo) {
                CreateMeetingMemoFeature()
            }
            Scope(state: /State.createSuccess, action: /Action.createSuccess) {
                CreateMeetingSuccessFeature()
            }
        }
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }

            case .nextButtonTapped:
                state.path.append(.meetingPlace(CreateMeetingPlaceFeature.State()))
                return .none

                // MARK: - Child

                // 모임 장소
            case let .path(.element(id: id, action: .meetingPlace(.delegate(.moveToNext)))):
                _ = id
                state.path.append(.meetingDate(CreateMeetingDateFeature.State()))
                return .none

                // 모임 날짜
            case let .path(.element(id: id, action: .meetingDate(.delegate(.moveToNext)))):
                _ = id
                state.path.append(.meetingMemo(CreateMeetingMemoFeature.State()))
                return .none

                // 모임 메모
            case let .path(.element(id: id, action: .meetingMemo(.delegate(.moveToNext)))):
                _ = id
                state.path.append(.createSuccess(CreateMeetingSuccessFeature.State()))
                return .none

                // 성공
            case let .path(.element(id: id, action: .createSuccess(.delegate(.moveToHome)))):
                _ = id
                return .none

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Child()
        }
    }
}
