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

        var textFieldState = BaggleTextFieldFeature.State(maxCount: 10,
                                                          textFieldState: .inactive)
        var alertState = BaggleAlertFeature.State(isPresented: false)
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case shareButtonTapped
        case invitationSuccess
        case invitationFailed
        case textFieldAction(BaggleTextFieldFeature.Action)
        case alertAction(BaggleAlertFeature.Action)
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.textFieldState, action: /Action.textFieldAction) {
            BaggleTextFieldFeature()
        }

        Scope(state: \.alertState, action: /Action.alertAction) {
            BaggleAlertFeature()
        }

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

            default:
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
