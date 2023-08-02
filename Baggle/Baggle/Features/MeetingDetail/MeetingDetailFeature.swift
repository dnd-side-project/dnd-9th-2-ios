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

    struct State: Equatable {
        // MARK: - Scope State

        var meetingId: Int
        var meetingData: MeetingDetail?

        // Alert
        var alertType: MeetingDeleteType = .delete
        var isAlertPresented: Bool = false
        var alertTitle: String = ""
        var alertDescription: String?
        var alertRightButtonTitle: String = ""

        // delete
        @PresentationState var selectOwner: SelectOwnerFeature.State?
        var nextOwnerId: Int?
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case updateData(MeetingDetail)
        case presentAlert
        case deleteMeeting

        // button
        case deleteButtonTapped
        case leaveButtonTapped
        case backButtonTapped

        case selectOwner(PresentationAction<SelectOwnerFeature.Action>)

        // delegate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case deleteSuccess
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.meetingDetailService) var meetingService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .onAppear:
                let id = state.meetingId
                return .run { send in
                    if let data = await meetingService.fetchMeetingDetail(id) {
                        await send(.updateData(data))
                    }
                }

            case .updateData(let data):
                state.meetingData = data
                return .none

            case .presentAlert:
                state.alertTitle = (state.meetingData?.name ?? "-") + state.alertType.title
                state.alertDescription = state.alertType.description
                state.alertRightButtonTitle = state.alertType.rightButtonTitle
                state.isAlertPresented.toggle()
                return .none

            case .deleteMeeting:
                return .run { send in
                    // 삭제 서버 통신
                    await send(.delegate(.deleteSuccess))
                }

            case .deleteButtonTapped:
                state.alertType = .delete
                return .run { send in
                    await send(.presentAlert)
                }

            case .leaveButtonTapped:
                state.alertType = .leave
                state.selectOwner = SelectOwnerFeature.State(
                    memberList: state.meetingData?.members ?? [])
                return .none

            case .backButtonTapped:
                return .run { _ in
                    await dismiss()
                }

            case .selectOwner(.presented(.leaveButtonTapped)):
                if let nextOwnerId = state.selectOwner?.selectedMemberId {
                    state.nextOwnerId = nextOwnerId
                }
                return .run { send in
                    await send(.presentAlert)
                }

            case .selectOwner:
                return .none

            case .delegate(.deleteSuccess):
                state.isAlertPresented.toggle()
                return .run { _ in
                    await dismiss()
                }

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$selectOwner, action: /Action.selectOwner) {
            SelectOwnerFeature()
        }
    }
}
