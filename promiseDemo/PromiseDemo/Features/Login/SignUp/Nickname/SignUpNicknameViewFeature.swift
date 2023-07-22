//
//  SignUpFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import ComposableArchitecture

struct SignUpNicknameFeature: ReducerProtocol {

    struct State: Equatable {
        var path = StackState<SignUpProfileImageFeature.State>()
    }

    enum Action: Equatable {
        case path(StackAction<SignUpProfileImageFeature.State, SignUpProfileImageFeature.Action>)
        case nextButtonTapped
        case cancelButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {
            case .path:
                return .none

            case .nextButtonTapped:
                return .none

            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            }
        }
        .forEach(\.path, action: /Action.path) {
            SignUpProfileImageFeature()
        }
    }
}
