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

        // Create Model
        var meetingCreate = MeetingCreateModel(title: nil, place: nil, time: nil, memo: nil)
        
        // Button
        var nextButtonDisabled: Bool = true

        // Child State
        var textFieldState = BaggleTextFeature.State(
            maxCount: 15,
            textFieldState: .inactive,
            isFocused: true
        )
        var path = StackState<Child.State>()
    }

    enum Action: Equatable {

        // Navigation Bar
        case backButtonTapped
        
        // View
        case onAppear

        // Tap
        case cancelButtonTapped
        case nextButtonTapped
        case submitButtonTapped

        // Move Screen
        case moveToNextScreen

        // Child Action
        case textFieldAction(BaggleTextFeature.Action)
        case path(StackAction<Child.State, Child.Action>)
        
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case moveToLogin
        }
    }

    struct Child: ReducerProtocol {

        enum State: Equatable {
            case meetingPlace(CreatePlaceFeature.State)
            case meetingDate(CreateDateFeature.State)
            case meetingMemo(CreateMemoFeature.State)
            case createSuccess(CreateSuccessFeature.State)
        }

        enum Action: Equatable {
            case meetingPlace(CreatePlaceFeature.Action)
            case meetingDate(CreateDateFeature.Action)
            case meetingMemo(CreateMemoFeature.Action)
            case createSuccess(CreateSuccessFeature.Action)
        }

        var body: some ReducerProtocolOf<Self> {
            Scope(state: /State.meetingPlace, action: /Action.meetingPlace) {
                CreatePlaceFeature()
            }
            Scope(state: /State.meetingDate, action: /Action.meetingDate) {
                CreateDateFeature()
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
            BaggleTextFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

                // Navigation Bar
                
            case .backButtonTapped:
                return .run { _ in await self.dismiss() }
                
                // View
            case .onAppear:
                return .run { send in await send(.textFieldAction(.isFocused(true)))}

                // Tap
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }

            case .nextButtonTapped:
                state.meetingCreate = state.meetingCreate.update(title: state.textFieldState.text)
                return .run { send in await send(.moveToNextScreen)}

            case .submitButtonTapped:
                if state.textFieldState.text.isEmpty {
                    return .run { send in
                        await send(.textFieldAction(.changeState(.invalid("제목을 입력해주세요."))))
                    }
                } else {
                    state.meetingCreate = state.meetingCreate.update(
                        title: state.textFieldState.text
                    )
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

                // MARK: - 모임 장소
            case let .path(.element(id: id, action: .meetingPlace(.delegate(.moveToNext(place))))):
                _ = id
                state.meetingCreate = state.meetingCreate.update(place: place)
                state.path.append(.meetingDate(CreateDateFeature.State()))
                return .none
                
            case let .path(.element(id: id, action: .meetingPlace(.delegate(.moveToBack)))):
                state.path.pop(from: id)
                return .none
                
            case let .path(.element(id: id, action: .meetingPlace(.delegate(.moveToHome)))):
                _ = id
                return .run { _ in await self.dismiss() }

                // MARK: - 모임 날짜
                
            case let .path(
                .element(id: id, action: .meetingDate(.delegate(.moveToNext(meetingTime))))
            ):
                _ = id
                state.meetingCreate = state.meetingCreate.update(time: meetingTime)
                state.path.append(.meetingMemo(
                    CreateMemoFeature.State(meetingCreate: state.meetingCreate))
                )
                return .none

            case let .path(.element(id: id, action: .meetingDate(.delegate(.moveToBack)))):
                state.path.pop(from: id)
                return .none
                
            case let .path(.element(id: id, action: .meetingDate(.delegate(.moveToHome)))):
                _ = id
                return .run { _ in await self.dismiss() }
                
                // MARK: - 모임 메모
            case let .path(
                .element(id: id, action: .meetingMemo(.delegate(.moveToNext(meetingSuccessModel))))
            ):
                _ = id
                state.path.append(.createSuccess(
                    CreateSuccessFeature.State(meetingSuccessModel: meetingSuccessModel))
                )
                return .none
                
            case let .path(.element(id: id, action: .meetingMemo(.delegate(.moveToBack)))):
                state.path.pop(from: id)
                return .none
                
            case let .path(.element(id: id, action: .meetingMemo(.delegate(.moveToHome)))):
                _ = id
                return .run { _ in await self.dismiss() }
                
            case let .path(.element(id: id, action: .meetingMemo(.delegate(.moveToLogin)))):
                _ = id
                return .run { send in await send(.delegate(.moveToLogin)) }

                // MARK: - 성공
                
            case let .path(.element(id: id, action: .createSuccess(.delegate(.moveToHome)))):
                _ = id
                return .run { _ in await dismiss() }

            case .path:
                return .none
                
                // MARK: - Delegate
                
            case .delegate:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Child()
        }
    }
}
