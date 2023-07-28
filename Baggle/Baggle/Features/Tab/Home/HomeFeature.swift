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

    struct State: Equatable {
        static func == (lhs: HomeFeature.State, rhs: HomeFeature.State) -> Bool {
            return lhs.shareButtonState == rhs.shareButtonState
        }

        // MARK: - Scope State

        @SwiftUI.State var shareButtonState: ButtonState = .enable
    }

    enum Action: Equatable {
        // MARK: - Scope Action

        case shareButtonTapped
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        // MARK: - Reduce

        Reduce { _, action in

            switch action {
            case .shareButtonTapped:
                sendKakaoMessage()
                return .none
            }
        }
    }

    func sendKakaoMessage() {
        if ShareApi.isKakaoTalkSharingAvailable() {
            let appLink = Link(iosExecutionParams: ["name": "콩이네 집들이"])
            let button = Button(title: "모임 참여하기", link: appLink)
            let thumbnailUrl = URL(string: "https://picsum.photos/200")

            let content = Content(title: "콩이네 집들이",
                                  imageUrl: thumbnailUrl!,
                                  link: appLink)
            let template = FeedTemplate(content: content, buttons: [button])

            if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)),
               let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                ShareApi.shared
                    .shareDefault(templateObject: templateJsonObject) { linkresult, error in
                        if let error = error {
                            print("error: \(error)")
                        } else {
                            guard let linkresult = linkresult else { return }
                            openURL(linkresult.url)
                        }
                    }
            }
        } else {
            moveToAppStore()
        }
    }

    func moveToAppStore() {
        let url = "itms-apps://itunes.apple.com/app/362057947"
        if let url = URL(string: url) {
            openURL(url)
        }
    }
}
