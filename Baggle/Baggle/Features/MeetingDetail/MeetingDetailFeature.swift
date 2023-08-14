//
//  MeetingDetailFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture
import KakaoSDKShare

struct MeetingDetailFeature: ReducerProtocol {

    @Environment(\.openURL) private var openURL

    struct State: Equatable {
        
        // View
        var isLoading: Bool = false
        
        // Meeting

        var meetingId: Int
        var meetingData: MeetingDetail?
        var dismiss: Bool = false
        var buttonState: MeetingDetailButtonType = .none

        // Alert
        var isErrorAlertPresented: Bool = false
        var errorDescription: String = ""
        var isDeleteAlertPresented: Bool = false
        var isLeaveAlertPresented: Bool = false
        var isInvitationAlertPresented: Bool = false
        
        // Feed
        var isImageTapped: Bool = false
        var tappedImageUrl: String?

        // Child
        var timerState = TimerFeature.State(timerCount: 0)

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
        case handleResult(MeetingDetailStatus)
        case updateData(MeetingDetail)
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

        // Alert
        case presentErrorAlert(String)
        case presentDeleteAlert
        case presentLeaveAlert
        case presentInvitationAlert
        
        // Alert - Tapped
        case errorAlertButtonTapped
        
        // Child
        case selectOwner(PresentationAction<SelectOwnerFeature.Action>)
        case usingCamera(PresentationAction<CameraFeature.Action>)
        case emergencyAction(PresentationAction<EmergencyFeature.Action>)
        case timerAction(TimerFeature.Action)

        // Timer - State
        case timerCountChanged
        
        // delegate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case deleteSuccess
            case onDisappear
        }
    }

    @Dependency(\.meetingDetailService) var meetingDetailService
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
                
                if meetingID == Const.ErrorID.meeting {
                    return .run { send in
                        await send(.presentErrorAlert("홈에서 모임 정보를 전달하는데 에러가 발생했어요"))
                    }
                }
                state.isLoading = true
                
                return .run { send in
                    let result = await meetingDetailService.fetchMeetingDetail(meetingID)
                    await send(.handleResult(result))
                }

            case .handleResult(let meetingDetailStatus):
                state.isLoading = false
                
                return .run { send in
                    switch meetingDetailStatus {
                    case let .success(meetingDetail):
                        await send(.updateData(meetingDetail))
                    case let .fail(apiError):
                        await send(.presentErrorAlert("네트워크 에러 \(apiError)"))
                    case .userError:
                        await send(.presentErrorAlert("로컬에 저장된 유저 정보를 가져오는데 에러가 발생했어요."))
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
                        return .run { send in await send(.timerCountChanged) }
                    }
                }

                return .none

            case .deleteMeeting:
                return .run { send in
                    // 삭제 서버 통신에 따라 분기처리
                    await send(.delegate(.deleteSuccess))
                }

                // Tap

            case .deleteButtonTapped:
                return .run { send in await send(.presentDeleteAlert) }

            case .leaveButtonTapped:
                state.selectOwner = SelectOwnerFeature.State(
                    memberList: state.meetingData?.members ?? []
                )
                return .run { send in await send(.presentLeaveAlert) }

            case .backButtonTapped:
                state.dismiss = true
                return .none

            case .cameraButtonTapped:
                if let emergencyButtonActiveTime = state.meetingData?.emergencyButtonActiveTime {
                    let timerCount = emergencyButtonActiveTime.authenticationTimeout()
                    state.usingCamera = CameraFeature.State(
                        timer: TimerFeature.State(timerCount: timerCount)
                    )
                } else {
                    print("언래핑 에러")
                }
                return .none

            case .emergencyButtonTapped:
                state.emergencyState = EmergencyFeature.State()
                return .none

            case .inviteButtonTapped:
                guard let meetingData = state.meetingData else { return .none }
                return .run { send in
                    if ShareApi.isKakaoTalkSharingAvailable() {
                        if let url = await sendInvitation(
                            name: meetingData.name,
                            id: 1) { // TODO: - meetingData.id로 수정 (임시 id)
                            openURL(url)
                        } else {
                            await send(.presentInvitationAlert)
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

            case .imageTapped(let imageUrl):
                state.isImageTapped.toggle()
                state.tappedImageUrl = imageUrl
                return .none

                // Child - Delete

            case .selectOwner(.presented(.leaveButtonTapped)):
                if let nextOwnerId = state.selectOwner?.selectedMemberId {
                    state.nextOwnerId = nextOwnerId
                }
                return .run { send in await send(.presentLeaveAlert) }

            case .selectOwner:
                return .none

            case .presentErrorAlert(let description):
                state.errorDescription = description
                state.isErrorAlertPresented.toggle()
                return .none

            case .presentDeleteAlert:
                return .none

            case .presentLeaveAlert:
                return .none

            case .presentInvitationAlert:
                state.isInvitationAlertPresented.toggle()
                return .none
                
            case .errorAlertButtonTapped:
                return .run { send in await send(.delegate(.onDisappear)) }

                // Child - Camera

            case .usingCamera:
                return .none

            case .emergencyAction(.presented(.delegate(.usingCamera))):
                state.emergencyState = nil
                return .run { send in await send(.cameraButtonTapped)}

            case .emergencyAction:
                return .none

                // Child - Timer
                
            case .timerAction(.timerOver):
                state.buttonState = .none
                return .none
                
            case .timerAction:
                return .none

                // Timer - State
                
            case .timerCountChanged:
                if let emergencyButtonActiveTime = state.meetingData?.emergencyButtonActiveTime {
                    state.timerState.timerCount = emergencyButtonActiveTime.authenticationTimeout()
                } else {
                    print("언래핑 에러")
                }
                
                // button의 onAppear 때 타이머 시작이 되기 때문에, 타이머 시간을 설정하고 버튼이 나타나야함
                // 아니면 버튼이 바로 사라짐
                state.buttonState = .authorize

                return .none
                
                // Delegate

            case .delegate(.deleteSuccess):
                state.isDeleteAlertPresented = false
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
