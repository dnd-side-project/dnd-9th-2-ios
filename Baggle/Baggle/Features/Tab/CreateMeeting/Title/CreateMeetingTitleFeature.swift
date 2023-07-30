//
//  CreateMeetingFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/24.
//

import ComposableArchitecture

struct CreateMeetingTitleFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State

        var path = StackState<CreateMeetingPlaceFeature.State>()
    }

    enum Action: Equatable {

        // MARK: - Tap
        case cancelButtonTapped

        // MARK: - Scope Action

        case path(StackAction<CreateMeetingPlaceFeature.State, CreateMeetingPlaceFeature.Action>)
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            CreateMeetingPlaceFeature()
        }
    }
}
