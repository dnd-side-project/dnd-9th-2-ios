//
//  CreateMeetingSuccessFeature.swift
//  Baggle
//
//  Created by youtak on 2023/07/31.
//

import SwiftUI

import ComposableArchitecture
import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate

struct CreateSuccessFeature: ReducerProtocol {

    struct State: Equatable {
        var meetingSuccessModel: MeetingSuccessModel
        // MARK: - Scope State
    }

    enum Action: Equatable {

        case kakaoInviteButtonTapped
        case sendLaterButtonTapped

        // MARK: - Delegate
        case delegate(Delegate)

        enum Delegate {
            case moveToHome
        }
    }

    @Environment(\.openURL) private var openURL

    @Dependency(\.sendInvitation) private var sendInvitation

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

            case .kakaoInviteButtonTapped:
                let meetingTitle = state.meetingSuccessModel.title
                let meetingId = state.meetingSuccessModel.id
                return .run { _ in
                    if ShareApi.isKakaoTalkSharingAvailable() {
                        if let url = await sendInvitation(
                            name: meetingTitle,
                            id: meetingId
                        ) {
                            openURL(url)
                        } else {
                            // 실패
                        }
                    } else {
                        moveToAppStore()
                    }
                }

            case .sendLaterButtonTapped:
                return .run { send in await send(.delegate(.moveToHome)) }

            case .delegate(.moveToHome):
                return .none
            }
        }
    }

    @Sendable func moveToAppStore() {
        let url = Const.URL.kakaoAppStore
        if let url = URL(string: url) {
            openURL(url)
        }
    }
}
