//
//  MeetingDetailFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import ComposableArchitecture

enum MeetingDetailState {
    case empty
    case updatedData(MeetingDetail)
}

struct MeetingDetailFeature: ReducerProtocol {

    var meetingId: Int

    struct State: Equatable {
        // MARK: - Scope State

        var meetingData: MeetingDetail?
        var isDeleted: Bool = false
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case updateData(MeetingDetail?)
        case deleteMeeting
    }

    @Dependency(\.meetingDetailService) var meetingService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .onAppear:
                return .run { send in
                    let data = await meetingService.fetchMeetingDetail(meetingId)
                    await send(.updateData(data))
                }

            case .updateData(let data):
                state.meetingData = data
                return .none

            case .deleteMeeting:
                state.isDeleted = true
                return .none
            }
        }
    }
}
