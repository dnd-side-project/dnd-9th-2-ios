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

        Reduce { _, action in

            switch action {

            case .kakaoInviteButtonTapped:
                return .run { _ in
                    if ShareApi.isKakaoTalkSharingAvailable() {
                        if let url = await sendInvitation(name: "집들이집들", id: 1000) {
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
        let url = "itms-apps://itunes.apple.com/app/362057947"
        if let url = URL(string: url) {
            openURL(url)
        }
    }
}
