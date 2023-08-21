//
//  LottieType.swift
//  Baggle
//
//  Created by youtak on 2023/08/18.
//

import Foundation

enum LottieType {
    case splash
    case button
}

extension LottieType {
    var filename: String {
        switch self {
        case .splash: return "SplashScreen_animation"
        case .button: return "Button_animation"
        }
    }
}
