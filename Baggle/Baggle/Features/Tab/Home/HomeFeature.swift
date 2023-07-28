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

struct HomeFeature: ReducerProtocol {

    @Environment(\.openURL) private var openURL
    @Dependency(\.sendInvitation) private var sendInvitation

    struct State: Equatable {
        // MARK: - Scope State
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case shareButtonTapped
        case invitationSuccess
        case invitationFailed
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { _, action in

            switch action {
            case .shareButtonTapped:
                return .run { send in
                    if ShareApi.isKakaoTalkSharingAvailable() {
                        if let url = await sendInvitation(name: "집들이집들") {
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
