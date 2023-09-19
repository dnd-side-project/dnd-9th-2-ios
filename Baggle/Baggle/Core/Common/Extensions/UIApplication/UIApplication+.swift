//
//  UIApplication+.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/19.
//

import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        Self.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }
}
