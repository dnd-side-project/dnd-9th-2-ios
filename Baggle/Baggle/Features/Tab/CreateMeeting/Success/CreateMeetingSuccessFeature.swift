//
//  CreateMeetingSuccessFeature.swift
//  Baggle
//
//  Created by youtak on 2023/07/31.
//

import ComposableArchitecture

struct CreateMeetingSuccessFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State
    }

    enum Action: Equatable {

        case completeButtonTapped

        // MARK: - Delegate
        case delegate(Delegate)

        enum Delegate {
            case moveToHome
        }
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { _, action in

            switch action {

            case .completeButtonTapped:
                return .run { send in await send(.delegate(.moveToHome)) }

            case .delegate(.moveToHome):
                return .none
            }
        }
    }
}
