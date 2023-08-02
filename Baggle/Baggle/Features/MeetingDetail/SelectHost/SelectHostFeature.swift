//
//  SelectHostFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/03.
//

import ComposableArchitecture

struct SelectHostFeature: ReducerProtocol {

    struct State: Equatable {

        // MARK: - Scope State

        var leaveButtonDisabled: Bool = true
        var selectedMemberId: Int?
        var memberList: [Member]
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case leaveButtonTapped
        case selectMember(Int)
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .leaveButtonTapped:
                return .none

            case .selectMember(let id):
                state.selectedMemberId = id
                state.leaveButtonDisabled = false
                return .none
            }
        }
    }
}
