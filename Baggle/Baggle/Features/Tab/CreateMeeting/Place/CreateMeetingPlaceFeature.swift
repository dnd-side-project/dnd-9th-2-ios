//
//  CreateMeetingPlaceFeature.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import ComposableArchitecture

struct CreateMeetingPlaceFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State

        var path = StackState<CreateMeetingDateFeature.State>()
    }

    enum Action: Equatable {

        // MARK: - Tap

        case nextButtonTapped

        // MARK: - Scope Action

        case path(StackAction<CreateMeetingDateFeature.State, CreateMeetingDateFeature.Action>)
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

            case .nextButtonTapped: 
                return .none

            case .path:
                return .none
            }
        }
    }
}
