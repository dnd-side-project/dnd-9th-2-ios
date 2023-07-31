//
//  CreateMeetingPlaceFeature.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import ComposableArchitecture

struct CreatePlaceFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State
    }

    enum Action: Equatable {

        // MARK: - Tap

        case nextButtonTapped

        // MARK: - Scope Action
        case delegate(Delegate)

        enum Delegate {
            case moveToNext
        }
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { _, action in

            switch action {

            case .nextButtonTapped:
                return .run { send in await send(.delegate(.moveToNext)) }

            case .delegate(.moveToNext):
                return .none
            }
        }
    }
}
