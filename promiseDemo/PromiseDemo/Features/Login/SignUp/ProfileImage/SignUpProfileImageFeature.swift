//
//  SignUpProfileImageFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import ComposableArchitecture

struct SignUpProfileImageFeature: ReducerProtocol {

    struct State: Equatable {
    }

    enum Action: Equatable {
        case nextButtonTapped
        case backButtonTapped
        case loginSuccess
    }

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {

            case .nextButtonTapped:
                return .none

            case .backButtonTapped:
                return .none

            case .loginSuccess:
                return .none
            }
        }
    }
}
