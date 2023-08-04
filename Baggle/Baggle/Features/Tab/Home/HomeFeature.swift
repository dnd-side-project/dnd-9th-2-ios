//
//  HomeFeature.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/26.
//

import Foundation
import SwiftUI

import ComposableArchitecture
import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate

enum MeetingStatus {
    case ongoing
    case complete

    var title: String {
        switch self {
        case .ongoing: return "예정된 약속"
        case .complete: return "지난 약속"
        }
    }
}

struct HomeFeature: ReducerProtocol {

    @Environment(\.openURL) private var openURL

    struct State: Equatable {
        // MARK: - Scope State

        var meetingStatus: MeetingStatus = .ongoing
        var pushMeetingDetailId: Int?
        var ongoingList: [Meeting] = []
        var completedList: [Meeting] = []
        var path = StackState<MeetingDetailFeature.State>()
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case fetchMeetingList(MeetingStatus)
        case updateMeetingList(MeetingStatus, [Meeting]?)
        case refreshMeetingList
        case changeMeetingStatus(MeetingStatus)
        case shareButtonTapped
        case invitationSuccess
        case invitationFailed
        case moveToMeetingDetail(Int)
        case path(StackAction<MeetingDetailFeature.State, MeetingDetailFeature.Action>)
    }

    @Dependency(\.sendInvitation) private var sendInvitation
    @Dependency(\.meetingService) var meetingService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .onAppear:
                if state.ongoingList.isEmpty && state.completedList.isEmpty {
                    return .run { send in
                        await send(.fetchMeetingList(.ongoing))
                    }
                } else {
                    return .none
                }

            case .fetchMeetingList(let status):
                state.meetingStatus = status
                return .run { send in
                    let list = await meetingService.fetchMeetingList(status)
                    await send(.updateMeetingList(status, list))
                }

            case .refreshMeetingList:
                state.ongoingList.removeAll()
                state.completedList.removeAll()
                state.meetingStatus = .ongoing
                return .run { send in
                    let list = await meetingService.fetchMeetingList(.ongoing)
                    await send(.updateMeetingList(.ongoing, list))
                }

            case .changeMeetingStatus(let status):
                state.meetingStatus = status
                if status == .complete && state.completedList.isEmpty {
                    return .run { send in
                        await send(.fetchMeetingList(.complete))
                    }
                }
                return .none

            case .updateMeetingList(let type, let model):
                if let model {
                    if type == .ongoing {
                        state.ongoingList.append(contentsOf: model)
                    } else {
                        state.completedList.append(contentsOf: model)
                    }
                }
                return .none

            case .shareButtonTapped:
                return .run { send in
                    if ShareApi.isKakaoTalkSharingAvailable() {
                        if let url = await sendInvitation(name: "집들이집들", id: 1000) {
                            openURL(url)
                            await send(.invitationSuccess)
                        } else {
                            await send(.invitationFailed)
                        }
                    } else {
                        moveToAppStore()
                    }
                }

            case .invitationSuccess:
                print("초대하기 성공")
                return .none

            case .invitationFailed:
                print("초대하기 실패")
                return .none

            case .moveToMeetingDetail(let id):
                state.pushMeetingDetailId = id
                return .none

            case .path(.element(id: _, action: .delegate(.deleteSuccess))):
                return .run { send in
                    await send(.refreshMeetingList)
                }

            case .path:
                return .none
            }

            @Sendable func moveToAppStore() {
                let url = "itms-apps://itunes.apple.com/app/362057947"
                if let url = URL(string: url) {
                    openURL(url)
                }
            }
        }
        .forEach(\.path, action: /Action.path) {
            MeetingDetailFeature()
        }
    }
}
