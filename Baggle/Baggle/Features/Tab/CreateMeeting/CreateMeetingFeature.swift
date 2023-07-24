//
//  CreateMeetingFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/24.
//

import ComposableArchitecture

struct CreateMeetingFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State
    }

    enum Action: Equatable {

        // MARK: - Tap
        case cancelButtonTapped

        // MARK: - Scope Action
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { _, action in

            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
