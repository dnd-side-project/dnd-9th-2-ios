//
//  CameraService.swift
//  Baggle
//
//  Created by youtak on 2023/08/05.
//

import SwiftUI

import ComposableArchitecture

struct CameraService {
    public let start: () async -> Void
    public let stop: () -> Void
    public let switchCaptureDevice: () async -> Void
    public let takePhoto: () async -> UIImage
    public let previewStream: () -> AsyncStream<CIImage>
}

extension CameraService: DependencyKey {

    static let liveValue: CameraService = {

        var camera = Camera()

        return Self { // start
            camera = Camera()
            await camera.start()
        } stop: {
            camera.stop()
        } switchCaptureDevice: {
            await camera.switchCaptureDevice()
        } takePhoto: {
            await camera.takePhoto()
        } previewStream: {
            camera.previewStream
        }
    }()
}

extension DependencyValues {
    var cameraService: CameraService {
        get { self[CameraService.self] }
        set { self[CameraService.self] = newValue }
    }
}
