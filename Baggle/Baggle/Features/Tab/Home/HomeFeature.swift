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
}

struct HomeFeature: ReducerProtocol {

    @Environment(\.openURL) private var openURL
    @Dependency(\.sendInvitation) private var sendInvitation

    struct State: Equatable {
        // MARK: - Scope State

        var meetingType: MeetingStatus = .ongoing
        var pushMeetingDetailId: Int?
        var ongoingList: [Meeting] = []
        var completedList: [Meeting] = []
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case onAppear
        case fetchMeetingList(MeetingStatus)
        case updateMeetings(MeetingStatus, [Meeting]?)
        case shareButtonTapped
        case invitationSuccess
        case invitationFailed
        case moveToMeetingDetail(Int)
    }

    @Dependency(\.meetingService) var meetingService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case .onAppear:
                return .run { send in
                    await send(.fetchMeetingList(.ongoing))
                }

            case .fetchMeetingList(let type):
                return .run { send in
                    let list = await meetingService.fetchMeetingList(type)
                    await send(.updateMeetings(type, list))
                }

            case .updateMeetings(let type, let model):
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
            }
        }
    }

    func moveToAppStore() {
        let url = "itms-apps://itunes.apple.com/app/362057947"
        if let url = URL(string: url) {
            openURL(url)
        }
    }
}
