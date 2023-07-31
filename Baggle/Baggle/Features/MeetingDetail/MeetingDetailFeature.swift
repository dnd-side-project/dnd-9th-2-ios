//
//  MeetingDetailFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import ComposableArchitecture

enum MeetingDetailState {
    case empty
    case updatedData(MeetingDetailModel)
}

struct MeetingDetailFeature: ReducerProtocol {

    var meetingId: Int

    struct State: Equatable {
        // MARK: - Scope State

        var meetingData: MeetingDetailModel?
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case updateData(MeetingDetailModel?)
    }

    @Dependency(\.meetingDetailService) var meetingService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .onAppear:
                return .run { send in
                    let data = await meetingService.getMeetingDetail(meetingId)
                    await send(.updateData(data))
                }

            case .updateData(let data):
                state.meetingData = data
                return .none
            }
        }
    }
}
