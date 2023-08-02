//
//  SelectOwnerFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/03.
//

import ComposableArchitecture

struct SelectOwnerFeature: ReducerProtocol {

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

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .leaveButtonTapped:
                return .run { _ in await self.dismiss() }

            case .selectMember(let id):
                state.selectedMemberId = id
                state.leaveButtonDisabled = false
                return .none
            }
        }
    }
}
