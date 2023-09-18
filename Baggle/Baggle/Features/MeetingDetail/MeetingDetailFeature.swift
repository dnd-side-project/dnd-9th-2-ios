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
        var isFeedActionSheetPresented: Bool = false

        // Meeting

        var meetingId: Int
        var meetingData: MeetingDetail?
        var dismiss: Bool = false
        var buttonState: MeetingDetailButtonType = .none
        
        // Feed
        var isImageTapped: Bool = false
        var tappedImageUrl: String?
        var feedReportRequestModel: FeedReportRequestModel?

        // Child
        var timerState = TimerFeature.State(timerCount: 0)

        // delete
        @PresentationState var selectOwner: SelectOwnerFeature.State?

        // Camera
        @PresentationState var usingCamera: CameraFeature.State?

        // Emergency
        @PresentationState var emergencyState: EmergencyFeature.State?
        
        // report
        @PresentationState var feedReport: FeedReportFeature.State?
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case notificationAppear(Int)
        
        // Meeting Detail
        case handleDetailResult(MeetingDetailResult)
        case updateData(MeetingDetail)
        case updateAfterMeetingEdit(MeetingEditSuccessModel)
        
        // Meeting Delete
        case deleteMeeting
        case leaveMeeting
        case handleDeleteResult(MeetingDeleteResult)

        // button
        case deleteButtonTapped
        case editButtonTapped
        case delegateButtonTapped
        case leaveButtonTapped
        
        case backButtonTapped
        case cameraButtonTapped
        case emergencyButtonTapped
        case inviteButtonTapped
        case eventButtonTapped
        case reportButtonTapped

        // feed
        case imageTapped(String?)
        case updateFeedReport(FeedReportRequestModel)

        // Alert
        case presentAlert(Bool)
        case alertTypeChanged(AlertMeetingDetailType)
        case alertButtonTapped
        
        // ActionSheet
        case presentActionSheet(Bool)
        case presentFeedActionSheet(Bool)
        
        // Child
        case selectOwner(PresentationAction<SelectOwnerFeature.Action>)
        case usingCamera(PresentationAction<CameraFeature.Action>)
        case emergencyAction(PresentationAction<EmergencyFeature.Action>)
        case timerAction(TimerFeature.Action)
        case feedReport(PresentationAction<FeedReportFeature.Action>)

        // Timer - State
        case timerCountChanged
        
        // delegate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case deleteSuccess
            case onDisappear
            case moveToLogin
            case moveToEdit(MeetingEditModel)
        }
    }

    @Dependency(\.meetingDetailService) var meetingDetailService
    @Dependency(\.meetingDeleteService) var meetingDeleteService
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
                    await send(.handleDetailResult(result))
                }
                
            case .notificationAppear(let id):
                state.meetingId = id
                return .run { send in await send(.onAppear) }

            case .handleDetailResult(let result):
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

            case .updateAfterMeetingEdit(let editedData):
                guard let editedMeeting = state.meetingData?.updateMeetingEdit(editedData) else {
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
                }
                return .run { send in await send(.updateData(editedMeeting))}
                
                // MARK: - Meeting Delete
                
            case .deleteMeeting:
                guard let meetingID = state.meetingData?.id else {
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
                }
                
                state.isLoading = true
                
                return .run { send in
                    let result = await meetingDeleteService.delete(meetingID)
                    await send(.handleDeleteResult(result))
                }
                
            case .leaveMeeting:
                guard let memberID = state.meetingData?.memberID else {
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
                }
                
                state.isLoading = true
                
                return .run { send in
                    let result = await meetingDeleteService.leave(memberID)
                    await send(.handleDeleteResult(result))
                }
                
            case .handleDeleteResult(let result):
                state.isLoading = false

                switch result {
                case .successDelegate:
                    return .run { send in await send(.alertTypeChanged(.meetingDelegateSuccess))}
                case .successLeave, .successDelete:
                    return .run { send in await send(.delegate(.deleteSuccess))}
                case .invalidDeleteTime:
                    return .run { send in await send(.alertTypeChanged(.invalidMeetingDelete))}
                case .networkError:
                    return .run { send in await send(.alertTypeChanged(.networkError("네트워크 에러")))}
                case .expiredToken:
                    return .run { send in await send(.alertTypeChanged(.networkError("토큰 만료")))}
                case .userError:
                    return .run { send in await send(.alertTypeChanged(.userError))}
                }
                
                // MARK: - Tap

            case .deleteButtonTapped:
                return .run { send in await send(.alertTypeChanged(.meetingDelete))}
                
            case .editButtonTapped:
                guard let meetingData = state.meetingData else {
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
                }
                
                guard meetingData.emergencyStatus == .scheduled else {
                    return .run { send in await send(.alertTypeChanged(.invalidMeetingEdit))}
                }
                
                guard let meetingEdit = meetingData.toMeetingEdit() else {
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
                }
                
                return .run { send in await send(.delegate(.moveToEdit(meetingEdit))) }

            case .delegateButtonTapped:
                guard let meetingData = state.meetingData else {
                    return .run { send in await send(.alertTypeChanged(.meetingUnwrapping))}
                }
                
                // 방장 혼자만 있는 경우
                if meetingData.members.count == 1 {
                    return .run { send in await send(.alertTypeChanged(.meetingDelegateFail))}
                } else {
                    state.selectOwner = SelectOwnerFeature.State()
                }
                return .none
                
            case .leaveButtonTapped:
                return .run { send in await send(.alertTypeChanged(.meetingLeave)) }
                
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
                
            case .updateFeedReport(let requestModel):
                state.feedReportRequestModel = requestModel
                return .none
                
            case .reportButtonTapped:
                state.feedReport = FeedReportFeature.State()
                return .none

                // Child - Delete

            case .selectOwner(.presented(.leaveButtonTapped)):
                guard let toMemberID = state.selectOwner?.selectedMemberID else {
                    print("방장 위임 - 선택된 ID 없음")
                    return .none
                }
                
                guard let myMemberID = state.meetingData?.memberID else {
                    print("방장 위임 - 모델 언래핑")
                    return .none
                }

                state.isLoading = true
                
                // 방장 위임
                return .run { send in
                    let result = await meetingDeleteService.delegateOwner(myMemberID, toMemberID)
                    await send(.handleDeleteResult(result))
                }

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
                case .networkError, .invalidAuthentication, .meetingUnwrapping:
                    return .none
                case .userError:
                    return .run { send in await send(.delegate(.moveToLogin))}
                case .invitation:
                    return .none
                case .meetingDelete: // 방 폭파
                    return .run { send in await send(.deleteMeeting)}
                case .meetingDelegateSuccess:
                    return .run { send in await send(.delegate(.deleteSuccess)) }
                case .meetingLeave: // 모임 나가기 (방장 아닌 사람)
                    return .run { send in await send(.leaveMeeting)}
                case .meetingDelegateFail, .invalidMeetingDelete:
                    return .none
                case .invalidMeetingEdit:
                    return .none
                }

                // Action Sheet
            case .presentActionSheet(let isPresented):
                state.isActionSheetPresented = isPresented
                return .none
                
            case .presentFeedActionSheet(let isPresented):
                state.isFeedActionSheetPresented = isPresented
                return .none
                
            case .feedReport(.presented(.reportTypeSelected(let reportType))):
                if let requestModel = state.feedReportRequestModel {
                    state.feedReportRequestModel = requestModel.updateReportType(reportType: reportType)
                    // TODO: - 신고 서버 통신
                }
                return .none
                
            case .feedReport(.presented(.disappear)):
                state.feedReportRequestModel = nil
                return .none
                
            case .feedReport:
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
        .ifLet(\.$feedReport, action: /Action.feedReport) {
            FeedReportFeature()
        }
    }
}
