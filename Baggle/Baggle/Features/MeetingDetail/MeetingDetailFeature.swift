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

    struct State: Equatable {
        // MARK: - Scope State

        var meetingId: Int
        var meetingData: MeetingDetail?
        var dismiss: Bool = false

        // Alert
        var alertType: MeetingDeleteType = .delete
        var isAlertPresented: Bool = false
        var alertTitle: String = ""
        var alertDescription: String?
        var alertRightButtonTitle: String = ""

        // delete
        @PresentationState var selectOwner: SelectOwnerFeature.State?
        var nextOwnerId: Int?

        // Camera
        @PresentationState var usingCamera: CameraFeature.State?

        // Emergency
        @PresentationState var emergencyState: EmergencyFeature.State?
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
        case cameraButtonTapped
        case emergencyButtonTapped

        // Child
        case selectOwner(PresentationAction<SelectOwnerFeature.Action>)
        case usingCamera(PresentationAction<CameraFeature.Action>)
        case emergencyAction(PresentationAction<EmergencyFeature.Action>)

        // delegate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case deleteSuccess
            case onDisappear
        }
    }

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
                    // 삭제 서버 통신에 따라 분기처리
                    await send(.delegate(.deleteSuccess))
                }

                // Tap

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
                state.dismiss = true
                return .none

            case .cameraButtonTapped:
                state.usingCamera = CameraFeature.State()
                return .none

            case .emergencyButtonTapped:
                state.emergencyState = EmergencyFeature.State()
                return .none

                // Child - Delete

            case .selectOwner(.presented(.leaveButtonTapped)):
                if let nextOwnerId = state.selectOwner?.selectedMemberId {
                    state.nextOwnerId = nextOwnerId
                }
                return .run { send in
                    await send(.presentAlert)
                }

            case .selectOwner:
                return .none

                // Child - Camera

            case .usingCamera:
                return .none

            case .emergencyAction(.presented(.delegate(.usingCamera))):
                state.usingCamera = CameraFeature.State()
                return .none

            case .emergencyAction:
                return .none

                // Delegate

            case .delegate(.deleteSuccess):
                state.isAlertPresented = false
                state.dismiss = true
                return .none

            case .delegate(.onDisappear):
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$selectOwner, action: /Action.selectOwner) {
            SelectOwnerFeature()
        }
        .ifLet(\.$usingCamera, action: /Action.usingCamera) {
            CameraFeature()
        }
        .ifLet(\.$emergencyState, action: /Action.emergencyAction) {
            EmergencyFeature()
        }
    }
}
