//
//  SignUpFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import ComposableArchitecture

struct SignUpNicknameFeature: ReducerProtocol {

    struct State: Equatable {
    }

    enum Action: Equatable {
        case moveToNextView
        case cancelButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {
            case .moveToNextView:
                return .none

            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
