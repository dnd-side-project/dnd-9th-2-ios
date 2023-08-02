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

enum MeetingDeleteType {
    case leave
    case delete

    var title: String {
        switch self {
        case .leave: return " 방을 나가시겠습니까?"
        case .delete: return " 방을 정말 폭파하시겠습니까?"
        }
    }

    var description: String {
        switch self {
        case .leave: return ""
        case .delete: return "방을 폭파하면 다시 되돌릴 수 없어요"
        }
    }

    var rightButtonTitle: String {
        switch self {
        case .leave: return "나가기"
        case .delete: return "폭파하기"
        }
    }
}

struct MeetingDetailFeature: ReducerProtocol {

    var meetingId: Int

    struct State: Equatable {
        // MARK: - Scope State

        var meetingData: MeetingDetail?

        // Alert

        var alertType: MeetingDeleteType = .delete
        var isAlertPresented: Bool = false
        var alertTitle: String = ""
        var alertDescription: String?
        var alertRightButtonTitle: String = ""

        var isDeleted: Bool = false
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case updateData(MeetingDetail)
        case showAlert(MeetingDeleteType)
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
                    if let data = await meetingService.fetchMeetingDetail(meetingId) {
                        await send(.updateData(data))
                    }
                }

            case .updateData(let data):
                state.meetingData = data
                return .none

            case .showAlert(let type):
                state.alertTitle = (state.meetingData?.name ?? "-") + type.title
                state.alertDescription = type.description
                state.alertRightButtonTitle = type.rightButtonTitle
                state.isAlertPresented.toggle()
                return .none

            case .deleteMeeting:
                state.isDeleted = true
                return .none
            }
        }
    }
}
