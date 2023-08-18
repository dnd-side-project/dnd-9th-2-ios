//
//  postObserverAction.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import Foundation
import SwiftUI

import ComposableArchitecture

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

extension ReducerProtocol {
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

extension View {
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
