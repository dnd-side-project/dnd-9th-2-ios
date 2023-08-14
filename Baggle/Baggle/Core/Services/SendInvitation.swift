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
    public func callAsFunction(name: String, id: Int) async -> URL? {
        if let templateJsonObject = createKakaoObject(name: name, id: id) {
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

    func createKakaoObject(name: String, id: Int) -> [String: Any]? {
        let appLink = Link(iosExecutionParams: ["name": name, "id": "\(id)"])
        let button = Button(title: "약속 참여하기", link: appLink)
        
        guard let thumbnailUrl = URL(string: Const.URL.invitationThumbnail) else { return nil }

        let content = Content(
            title: name,
            imageUrl: thumbnailUrl,
            description: "'\(name)' 약속에 초대합니다.\n지금 바로 참여해보세요!",
            link: appLink
        )
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
