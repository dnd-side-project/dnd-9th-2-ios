//
//  BaggleAlertFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/29.
//

import ComposableArchitecture

struct BaggleAlertFeature: ReducerProtocol {

    struct State: Equatable {
        // MARK: - Scope State

        var isPresented: Bool
    }

    enum Action: Equatable {
        // MARK: - Scope Action
        case changeState
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .changeState:
                state.isPresented.toggle()
                return .none
            }
        }
    }
}
