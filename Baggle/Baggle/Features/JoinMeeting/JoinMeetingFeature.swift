//
//  JoinMeetingFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct JoinMeetingFeature: ReducerProtocol {

    let meetingId: Int

    struct State: Equatable {
        // MARK: - Scope State
        var moveToMeetingDetail: Bool = false
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case dismiss
        case joinButtonTapped
        case joinSuccess
        case joinFailed
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .dismiss:
                return .none

            case .joinButtonTapped:
                return .run { send in
                    // id 값으로 참여 통신
                    await send(.joinSuccess)
                }

            case .joinSuccess:
                state.moveToMeetingDetail = true
                return .none

            case .joinFailed:
                return .none
            }
        }
    }
}
