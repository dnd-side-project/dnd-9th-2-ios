//
//  ImageSizeType.swift
//  Baggle
//
//  Created by youtak on 2023/08/17.
//

import SwiftUI

enum ImageSizeType {
    case small
    case medium
    case large
}

extension ImageSizeType {
    var size: CGFloat {
        switch self {
        case .small: return 320
        case .medium: return 640
        case .large: return 1080
        }
    }
}
