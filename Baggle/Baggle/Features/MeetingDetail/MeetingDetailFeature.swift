//
//  MeetingDetailFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture
import KakaoSDKShare

enum MeetingDetailState {
    case empty
    case updatedData(MeetingDetail)
}

struct MeetingDetailFeature: ReducerProtocol {

    @Environment(\.openURL) private var openURL

    struct State: Equatable {
        
        // User
        var userID: Int
        
        // Meeting

        var meetingId: Int
        var meetingData: MeetingDetail?
        var dismiss: Bool = false
        var buttonState: MeetingDetailButtonType = .none

        // Alert
        var alertType: MeetingDeleteType = .delete
        var isAlertPresented: Bool = false
        var alertTitle: String = ""
        var alertDescription: String?
        var alertRightButtonTitle: String = ""

        // Feed
        var isImageTapped: Bool = false
        var tappedImageUrl: String?

        // Child
        var timerState = TimerFeature.State(targetDate: Date().later(seconds: 4))

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
        case inviteButtonTapped
        case eventButtonTapped

        // feed
        case imageTapped(String?)

        // error
        case invitationFailed

        // Child
        case selectOwner(PresentationAction<SelectOwnerFeature.Action>)
        case usingCamera(PresentationAction<CameraFeature.Action>)
        case emergencyAction(PresentationAction<EmergencyFeature.Action>)
        case timerAction(TimerFeature.Action)

        // delegate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case deleteSuccess
            case onDisappear
        }
    }

    @Dependency(\.meetingDetailService) var meetingService
    @Dependency(\.sendInvitation) private var sendInvitation

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.timerState, action: /Action.timerAction) {
            TimerFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .onAppear:
                let meetingID = state.meetingId
                let userID = state.userID
                return .run { send in
                    if let data = await meetingService.fetchMeetingDetail(meetingID, userID) {
                        await send(.updateData(data))
                    }
                }

            case .updateData(let data):
                state.meetingData = data
                
                // 약속 상태가 ready 또는 progress이면 invite
                // 약속 상태가 confirmed이고, !emergencyButtonActive이고, 본인이 button 관리자이면 emergency
                // 약속 상태가 confirmed이고 emergencyButtonActive이고, 본인이 !certified이면
                if data.status == .ready || data.status == .progress {
                    state.buttonState = .invite
                } else if data.status == .confirmed {
                    if !data.emergencyButtonActive && data.isEmergencyAuthority {
                        state.buttonState = .emergency
                    } else if data.emergencyButtonActive && !data.isCertified {
                        state.buttonState = .authorize
                    }
                }

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

            case .inviteButtonTapped:
                return .run { send in
                    if ShareApi.isKakaoTalkSharingAvailable() {
                        if let url = await sendInvitation(name: "집들이집들", id: 1000) {
                            openURL(url)
                        } else {
                            await send(.invitationFailed)
                        }
                    } else {
                        let url = "itms-apps://itunes.apple.com/app/362057947"
                        if let url = URL(string: url) {
                            openURL(url)
                        }
                    }
                }

            case .eventButtonTapped:
                switch state.buttonState {
                case .emergency:
                    return .run { send in await send(.emergencyButtonTapped) }
                case .invite:
                    print("초대장 보내기")
                    return .run { send in await send(.inviteButtonTapped) }
                case .authorize:
                    return .run { send in await send(.cameraButtonTapped) }
                case .none:
                    break
                }
                return .none

            case .invitationFailed:
                print("초대 실패 alert")
                return .none

            case .imageTapped(let imageUrl):
                state.isImageTapped.toggle()
                state.tappedImageUrl = imageUrl
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
                state.emergencyState = nil
                return .run { send in await send(.cameraButtonTapped)}

            case .emergencyAction:
                return .none

                // Timer
                
            case .timerAction(.timerOver):
                state.buttonState = .none
                return .none
                
            case .timerAction:
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
