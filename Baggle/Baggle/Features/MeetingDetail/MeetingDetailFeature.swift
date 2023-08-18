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
        var memberId: Int = -1
        var dismiss: Bool = false
        var buttonState: MeetingDetailButtonType = .none

        // Alert
        var alertType: AlertMeetingDetailType?
        
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
        case presentAlert(Bool)
        case presentInvitationAlert
        case alertButtonTapped
        
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
            case moveToLogin
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
                state.alertType = .meetingNotFound
                return .none
                let meetingID = state.meetingId
                
                if meetingID == Const.ErrorID.meeting {
                    state.alertType = .meetingIDError
                    return .none
                }
                state.isLoading = true
                
                return .run { send in
                    let result = await meetingDetailService.fetchMeetingDetail(meetingID)
                    await send(.handleResult(result))
                }

            case .handleResult(let status):
                state.isLoading = false
                
                switch status {
                case let .success(meetingDetail):
                    return .run { send in await send(.updateData(meetingDetail)) }
                case .notFound:
                    state.alertType = .meetingNotFound
                    return .none
                case .userError:
                    state.alertType = .userError
                    return .none
                case .networkError(let description):
                    state.alertType = .networkError(description)
                    return .none
                }
                
            case .updateData(let data):
                state.meetingData = data
                state.memberId = data.memberId
                
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
                return .none

            case .leaveButtonTapped:
                state.selectOwner = SelectOwnerFeature.State(
                    memberList: state.meetingData?.members ?? []
                )
                return .none

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
                guard let remainTimeUntilExpired = state.meetingData?
                    .emergencyButtonExpiredTime
                    .remainingTime()
                else {
                    return .none
                }
                        
                state.emergencyState = EmergencyFeature.State(
                    memberID: state.meetingId,
                    remainTimeUntilExpired: remainTimeUntilExpired
                )
                return .none

            case .inviteButtonTapped:
                guard let meetingData = state.meetingData else { return .none }
                return .run { send in
                    if ShareApi.isKakaoTalkSharingAvailable() {
                        if let url = await sendInvitation(
                            name: meetingData.name,
                            id: 12
                        ) { // TODO: - meetingData.id로 수정 (임시 id)
                            openURL(url)
                        } else {
                            await send(.presentInvitationAlert)
                        }
                    } else {
                        if let url = URL(string: Const.URL.kakaoAppStore) {
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
                return .none

            case .selectOwner:
                return .none

                
                // Alert
                
            case .presentAlert(let isPresented):
                if !isPresented {
                    state.alertType = nil
                }
                return .none
                
            case .presentInvitationAlert:
                state.alertType = .invitation
                return .none

            case .alertButtonTapped:
                guard let alertType = state.alertType else {
                    return .none
                }
                state.alertType = nil
                
                switch alertType {
                case .meetingNotFound, .meetingIDError:
                    return .run { send in await send(.delegate(.onDisappear))}
                case .networkError:
                    return .none
                case .userError:
                    return .run { send in await send(.delegate(.moveToLogin))}
                case .invitation:
                    return .none
                case .delete:
                    // 삭제 요청
                    return .none
                }

                // Child - Camera

            case let .usingCamera(.presented(.delegate(.uploadSuccess(feed)))):
                if let meetingData = state.meetingData {
                    state.meetingData = meetingData.updateFeed(feed)
                }
                return .none
                
            case .usingCamera(.presented(.delegate(.moveToLogin))):
                return .run { send in await send(.delegate(.moveToLogin))}
                
            case .usingCamera:
                return .none

                // Child - emergency Button
                
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
                state.dismiss = true
                return .none

            case .delegate(.onDisappear):
                return .none
                
            case .delegate(.moveToLogin):
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
