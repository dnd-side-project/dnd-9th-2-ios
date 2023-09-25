//
//  CameraStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/14.
//

import SwiftUI

enum CameraStartResult {
    case success
    case deniedAuthorization
    case error
}

enum CameraTakePhotoResult {
    case success(UIImage)
    case error
}
