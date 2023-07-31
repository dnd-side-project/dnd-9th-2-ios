//
//  CreateMeetingFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/24.
//

import Foundation

import ComposableArchitecture

struct CreateTitleFeature: ReducerProtocol {

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
            case meetingPlace(CreatePlaceFeature.State)
            case meetingDate(CreateMeetingFeature.State)
            case meetingMemo(CreateMemoFeature.State)
            case createSuccess(CreateSuccessFeature.State)
        }

        enum Action: Equatable {
            case meetingPlace(CreatePlaceFeature.Action)
            case meetingDate(CreateMeetingFeature.Action)
            case meetingMemo(CreateMemoFeature.Action)
            case createSuccess(CreateSuccessFeature.Action)
        }

        var body: some ReducerProtocolOf<Self> {
            Scope(state: /State.meetingPlace, action: /Action.meetingPlace) {
                CreatePlaceFeature()
            }
            Scope(state: /State.meetingDate, action: /Action.meetingDate) {
                CreateMeetingFeature()
            }
            Scope(state: /State.meetingMemo, action: /Action.meetingMemo) {
                CreateMemoFeature()
            }
            Scope(state: /State.createSuccess, action: /Action.createSuccess) {
                CreateSuccessFeature()
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
                state.path.append(.meetingPlace(CreatePlaceFeature.State()))
                return .none

                // MARK: - Child

                // 모임 장소
            case let .path(.element(id: id, action: .meetingPlace(.delegate(.moveToNext)))):
                _ = id
                state.path.append(.meetingDate(CreateMeetingFeature.State()))
                return .none

                // 모임 날짜
            case let .path(.element(id: id, action: .meetingDate(.delegate(.moveToNext)))):
                _ = id
                state.path.append(.meetingMemo(CreateMemoFeature.State()))
                return .none

                // 모임 메모
            case let .path(.element(id: id, action: .meetingMemo(.delegate(.moveToNext)))):
                _ = id
                state.path.append(.createSuccess(CreateSuccessFeature.State()))
                return .none

                // 성공
            case let .path(.element(id: id, action: .createSuccess(.delegate(.moveToHome)))):
                _ = id
                return .run { _ in await dismiss() }

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Child()
        }
    }
}
