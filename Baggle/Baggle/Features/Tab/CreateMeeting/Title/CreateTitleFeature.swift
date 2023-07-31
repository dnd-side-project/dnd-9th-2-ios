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

        // Button
        var nextButtonDisabled: Bool = true

        // Child State
        var textFieldState = BaggleTextFieldFeature.State(maxCount: 20, textFieldState: .inactive)
        var path = StackState<Child.State>()
    }

    enum Action: Equatable {

        // View
        case onAppear

        // Tap
        case cancelButtonTapped
        case nextButtonTapped
        case submitButtonTapped

        // Move Screen
        case moveToNextScreen

        // Child Action
        case textFieldAction(BaggleTextFieldFeature.Action)
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

        // MARK: - Scope

        Scope(state: \.textFieldState, action: /Action.textFieldAction) {
            BaggleTextFieldFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

                // View
            case .onAppear:
                return .run { send in await send(.textFieldAction(.isFocused(true)))}

                // Tap
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }

            case .nextButtonTapped:
                return .run { send in await send(.moveToNextScreen)}

            case .submitButtonTapped:
                if state.textFieldState.text.isEmpty {
                    return .run { send in
                        await send(.textFieldAction(.changeState(.invalid("제목을 입력해주세요."))))
                    }
                } else {
                    return .run { send in await send(.moveToNextScreen)}
                }

            case .moveToNextScreen:
                state.path.append(.meetingPlace(CreatePlaceFeature.State()))
                return .none

                // MARK: - Child

                // TextField
            case let .textFieldAction(.textChanged(text)):
                if text.isEmpty {
                    state.nextButtonDisabled = true
                } else {
                    state.nextButtonDisabled = false
                }
                return .none

            case .textFieldAction:
                return .none

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
