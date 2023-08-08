//
//  BaggleStampStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/08.
//

import SwiftUI

enum BaggleStampStatus {
    case confirm
    case completed
    case fail
}

extension BaggleStampStatus {

    var image: Image {
        switch self {
        case .confirm: return Image.Stamp.confirm
        case .completed: return Image.Stamp.complete
        case .fail: return Image.Stamp.fail
        }
    }

    var degrees: Double {
        switch self {
        case .confirm: return -25
        case .completed: return -25
        case .fail: return -15
        }
    }
}
