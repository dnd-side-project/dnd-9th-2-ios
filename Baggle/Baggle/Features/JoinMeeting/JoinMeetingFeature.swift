//
//  JoinMeetingFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct JoinMeetingFeature: ReducerProtocol {

    // TODO: - State에서 제거
//    let meetingId: Int

    struct State: Equatable {
        // MARK: - Scope State
        var meetingId: Int
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case exitButtonTapped
        case joinButtonTapped
        case joinSuccess
        case joinFailed
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { _, action in

            switch action {
            case .exitButtonTapped:
                return .run { _ in await self.dismiss() }

            case .joinButtonTapped:
                return .run { send in
                    // id 값으로 참여 통신
                    await send(.joinSuccess)
                }

            case .joinSuccess:
                return .none

            case .joinFailed:
                return .none
            }
        }
    }
}
