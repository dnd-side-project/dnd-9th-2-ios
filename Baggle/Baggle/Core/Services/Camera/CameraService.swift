//
//  CameraService.swift
//  Baggle
//
//  Created by youtak on 2023/08/05.
//

import SwiftUI

import ComposableArchitecture

struct CameraService {
    public let start: () async -> CameraStartResult
    public let stop: () -> Void
    public let switchCaptureDevice: () async -> Void
    public let takePhoto: () async -> CameraTakePhotoResult
    public let previewStream: () -> AsyncStream<CIImage>
}

extension CameraService: DependencyKey {

    static let liveValue: CameraService = {

        var camera = Camera()

        return Self { // start
            camera = Camera()
            do {
                try await camera.start()
            } catch {
                if let cameraError = error as? CameraError, cameraError == .authorized {
                    return .deniedAuthorization
                } else {
                    return .error
                }
            }
            return .success
        } stop: {
            camera.stop()
        } switchCaptureDevice: {
            await camera.switchCaptureDevice()
        } takePhoto: {
            do {
                let resultImage = try await camera.takePhoto()
                return .success(resultImage)
            } catch {
                return .error
            }
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
