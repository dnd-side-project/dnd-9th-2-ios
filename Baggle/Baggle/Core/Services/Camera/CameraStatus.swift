//
//  CameraStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/14.
//

import SwiftUI

enum CameraStartStatus {
    case success
    case deniedAuthorization
    case error
}

enum CameraTakePhotoStatus {
    case success(UIImage)
    case error
}
