//
//  postObserverAction.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import Foundation

extension NSObject {
    func postObserverAction(
        _ keyName: Notification.Name,
        object: Any? = nil,
        userInfo: [AnyHashable: Any]? = nil
    ) {
        NotificationCenter.default.post(
            name: keyName,
            object: object,
            userInfo: userInfo
        )
    }
}
