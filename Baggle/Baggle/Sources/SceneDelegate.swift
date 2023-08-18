//
//  SceneDelegate.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?

    /// 앱 완전히 종료된 상태에서 푸시 받은 경우 처리 (not running)
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let notification = connectionOptions.notificationResponse {
            let userInfo = notification.notification.request.content.userInfo
            if let meetingId: Int = Int(userInfo["meetingId"] as? String ?? "") {
                // 최초 진입시 스플래시 애니메이션 시간 + 0.4
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.4) {
                    self.postObserverAction(.moveMeetingDetail, object: meetingId)
                }
            }
        }
    }
}
