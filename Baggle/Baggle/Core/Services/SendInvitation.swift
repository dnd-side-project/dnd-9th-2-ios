//
//  SendInvitation.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/28.
//

import SwiftUI

import Dependencies
import KakaoSDKCommon
import KakaoSDKShare
import KakaoSDKTemplate

public struct SendInvitationEffect: Sendable {

    var send: (@MainActor @Sendable (URL?) -> Void)?

    @MainActor
    public func callAsFunction(name: String) async -> URL? {
        if let templateJsonObject = createKakaoObject(name: name) {
            do {
                typealias ShareContinuation = CheckedContinuation<URL, Error>
                let linkResult =
                    try await withCheckedThrowingContinuation({(cont: ShareContinuation) in
                        ShareApi.shared
                            .shareDefault(templateObject: templateJsonObject) { linkresult, error in
                                if let error {
                                    print("error: \(error)")
                                    cont.resume(throwing: error)
                                } else {
                                    guard let linkresult = linkresult?.url else { return }
                                    cont.resume(returning: linkresult)
                                }
                            }
                    })
                send?(linkResult)
                return linkResult
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }

    func createKakaoObject(name: String) -> [String: Any]? {
        let appLink = Link(iosExecutionParams: ["name": name])
        let button = Button(title: "모임 참여하기", link: appLink)
        guard let thumbnailUrl = URL(string: "https://picsum.photos/200") else { return nil }

        let content = Content(title: "콩이네 집들이", imageUrl: thumbnailUrl, link: appLink)
        let template = FeedTemplate(content: content, buttons: [button])
        do {
            let templateJsonData = try SdkJSONEncoder.custom.encode(template)
            let templateJsonObject = SdkUtils.toJsonObject(templateJsonData)

            if let templateJsonObject {
                return templateJsonObject
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}

extension SendInvitationEffect {
    public init(_ send: @escaping @MainActor @Sendable (URL?) -> Void) {
        self.send = send
    }
}

extension DependencyValues {
    public var sendInvitation: SendInvitationEffect {
        get { self[SendInvitationKey.self] }
        set { self[SendInvitationKey.self] = newValue }
    }
}

private enum SendInvitationKey: DependencyKey {
    static let liveValue = SendInvitationEffect()
}
