//
//  MeetingDetailFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

// swiftlint:disable:next type_body_length
struct MeetingDetailFeature: ReducerProtocol {

    @Environment(\.openURL) private var openURL

    struct State: Equatable {
        
        // View
        var isLoading: Bool = false
        
        // Alert
        var isAlertPresented: Bool = false
        var alertType: AlertMeetingDetailType?
        
        // Action Sheet
        var isActionSheetPresented: Bool = false

        // Meeting

        var meetingId: Int
        var meetingData: MeetingDetail?
        var dismiss: Bool = false
        var buttonState: MeetingDetailButtonType = .none
        
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
        case notificationAppear(Int)
        
        case handleResult(MeetingDetailResult)
        case updateData(MeetingDetail)
        case deleteMeeting

        // button
        case deleteButtonTapped
        case editButtonTapped
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
        case alertTypeChanged(AlertMeetingDetailType)
        case alertButtonTapped
        
        // ActionSheet
        case presentActionSheet(Bool)
        
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
            case moveToEdit(MeetingEdit)
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
                    return .run { send in await send(.alertTypeChanged(.meetingIDError))}
                }
                state.isLoading = true
                
                return .run { send in
                    let result = await meetingDetailService.fetchMeetingDetail(meetingID)
                    await send(.handleResult(result))
                }
                
            case .notificationAppear(let id):
                state.meetingId = id
                return .run { send in await send(.onAppear) }

            case .handleResult(let result):
                state.isLoading = false
                
                switch result {
                case let .success(meetingDetail):
                    return .run { send in await send(.updateData(meetingDetail)) }
                case .notFound:
                    return .run { send in await send(.alertTypeChanged(.meetingNotFound))}
                case .userError:
                    return .run { send in await send(.alertTypeChanged(.userError))}
                case .networkError(let description):
                    return .run { send in await send(.alertTypeChanged(.networkError(description)))}
                }
                
            case .updateData(let data):
                state.meetingData = data
                
                let emergencyStatus = data.emergencyStatus

                if emergencyStatus == .scheduled {
                    state.buttonState = .invite
                } else if emergencyStatus == .confirmation {
                    if !data.emergencyButtonActive && data.isEmergencyAuthority {
                        state.buttonState = .emergency
                    }
                } else if emergencyStatus == .onGoing && !data.isCertified {
                    return .run { send in await send(.timerCountChanged) }
                } else {
                    state.buttonState = .none
                }
                return .none

            case .deleteMeeting:
                return .run { send in
                    // 삭제 서버 통신에 따라 분기처리
                    await send(.delegate(.deleteSuccess))
                }

                // MARK: - Tap

            case .deleteButtonTapped:
                return .run { send in await send(.alertTypeChanged(.meetingDelete))}
                
            case .editButtonTapped:
                guard let meetingEdit = state.meetingData?.toMeetingEdit() else {
                    // 실패시 MeetingDetail에서 Date생성하는 함수를 확인할 것
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
                }
                return .run { send in await send(.delegate(.moveToEdit(meetingEdit))) }

            case .leaveButtonTapped:
                
                guard let meetingData = state.meetingData else {
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
                }
                
                // 방장 혼자만 있는 경우
                if meetingData.members.count == 1 {
                    return .run { send in await send(.alertTypeChanged(.meetingLeaveFail))}
                } else {
                    state.selectOwner = SelectOwnerFeature.State()
                }
                return .none

            case .backButtonTapped:
                state.dismiss = true
                return .none

            case .cameraButtonTapped:
                guard let meetingData = state.meetingData else {
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
                }
                
                let memberID = meetingData.memberID
                
                if let emergencyButtonActiveTime = state.meetingData?.emergencyButtonActiveTime {
                    let timerCount = emergencyButtonActiveTime.authenticationTimeout()
                    state.usingCamera = CameraFeature.State(
                        memberID: memberID,
                        timer: TimerFeature.State(timerCount: timerCount)
                    )
                } else {
                    return .run { send in await send(.alertTypeChanged(.invalidAuthentication))}
                }
                return .none

            case .emergencyButtonTapped:
                guard let meetingData = state.meetingData else {
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
                }
                
                let memberID = meetingData.memberID
                let remainTimeUntilExpired = meetingData.emergencyButtonExpiredTime.remainingTime()
                        
                state.emergencyState = EmergencyFeature.State(
                    memberID: memberID,
                    remainTimeUntilExpired: remainTimeUntilExpired
                )
                return .none

            case .inviteButtonTapped:
                guard let meetingData = state.meetingData else { return .none }
                return .run { _ in
                    do {
                        if let url = try await sendInvitation(
                            name: meetingData.name,
                            id: meetingData.id
                        ) {
                            openURL(url)
                        } else {
                            guard let url = URL(string: Const.URL.kakaoAppStore) else { return }
                            openURL(url)
                        }
                    } catch {
                        print("카카오 링크 공유 실패")
                    }
                }

            case .eventButtonTapped:
                switch state.buttonState {
                case .emergency:
                    return .run { send in await send(.emergencyButtonTapped) }
                case .invite:
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
                state.isAlertPresented = isPresented
                return .none

            case .alertTypeChanged(let alertType):
                state.alertType = alertType
                state.isAlertPresented = true
                return .none

            case .alertButtonTapped:
                guard let alertType = state.alertType else {
                    return .none
                }
                state.alertType = nil
                
                switch alertType {
                case .meetingNotFound, .meetingIDError:
                    return .run { send in await send(.delegate(.onDisappear))}
                case .networkError, .invalidAuthentication, .meetingUnwrapping, .meetingLeaveFail:
                    return .none
                case .userError:
                    return .run { send in await send(.delegate(.moveToLogin))}
                case .invitation:
                    return .none
                case .meetingDelete:
                    //방 폭파
                    return .none
                case .delete:
                    // 삭제 요청
                    return .none
                }

                // Action Sheet
            case .presentActionSheet(let isPresented):
                state.isActionSheetPresented = isPresented
                return .none
                
                // Child - Camera

            case let .usingCamera(.presented(.delegate(.uploadSuccess(feed)))):
                guard let meetingData = state.meetingData else {
                    return .run { send in await send(.alertTypeChanged(.meetingNotFound))}
                }
                
                // 피드 & 멤버 데이터 업데이트
                let newMeeting = meetingData.updateFeed(feed)
                
                // 긴급 버튼 업데이트
                return .run { send in await send(.updateData(newMeeting))}
                
            case .usingCamera(.presented(.delegate(.moveToLogin))):
                return .run { send in await send(.delegate(.moveToLogin))}
                
            case .usingCamera:
                return .none

                // Child - emergency Button
                
            case .emergencyAction(.presented(.delegate(.usingCamera))):
                state.emergencyState = nil
                return .run { send in await send(.cameraButtonTapped) }

            case .emergencyAction(.presented(.delegate(.moveToBack))):
                state.emergencyState = nil
                return .none
                
            case .emergencyAction(.presented(.delegate(.moveToLogin))):
                return .run { send in await send(.delegate(.moveToLogin)) }
                
            case .emergencyAction(.presented(.delegate(.updateEmergencyState(let date)))):
                if let meetingData = state.meetingData {
                    let newData = meetingData.updateEmergemcy(date)
                    return .run { send in await send(.updateData(newData)) }
                }
                return .none
            
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
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
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
