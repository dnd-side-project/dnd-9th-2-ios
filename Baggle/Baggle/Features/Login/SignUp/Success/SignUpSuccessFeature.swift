//
//  SignUpProfileImageFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import ComposableArchitecture

struct SignUpSuccessFeature: ReducerProtocol {

    struct State: Equatable {
    }

    enum Action: Equatable {
        case nextButtonTapped
        case signUpSuccess

        case delegate(Delegate)

        enum Delegate: Equatable {
            case moveToNext
        }
    }

    var body: some ReducerProtocolOf<Self> {
        Reduce { _, action in

            switch action {

            case .nextButtonTapped:
                return .run { send in
                    // todo: 성공 & 실패 분기 처리
                    await send(.signUpSuccess)
                }

            case .signUpSuccess:
                return .run { send in
                    await send(.delegate(.moveToNext))
                }

            case .delegate:
                return .none
            }
        }
    }
}
