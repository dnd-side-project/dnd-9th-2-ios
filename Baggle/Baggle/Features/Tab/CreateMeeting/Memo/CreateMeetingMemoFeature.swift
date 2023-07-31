//
//  CreateMeetingMemoFeature.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import ComposableArchitecture

struct CreateMeetingMemoFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State
    }

    enum Action: Equatable {

        case nextButtonTapped

        // MARK: - Delegate
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
