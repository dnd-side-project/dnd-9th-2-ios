//
//  CameraFeature.swift
//  Baggle
//
//  Created by youtak on 2023/08/05.
//

import SwiftUI

import ComposableArchitecture

struct CameraFeature: ReducerProtocol {

    struct State: Equatable {
        var viewFinderImage: Image?
        var resultImage: UIImage?

        var flipImage: Image?
        var isFlipped: Bool = false
        var flipDegree: Double = 0.0

        var isCompleted: Bool = false

        //Timer
        var timer = TimerFeature.State()
    }

    enum Action: Equatable {
        case onAppear

        // Image
        case viewFinderUpdate(Image?)
        case flipImageRemove
        case flipDegreeUpdate
        case completeTakePhoto(UIImage?)

        // Tap - Camera
        case shutterTapped
        case switchButtonTapped
        case cancelButtonTapped

        // Tap - Photo
        case reTakeButtonTapped
        case uploadButtonTapped

        // Timer
        case timer(TimerFeature.Action)

        // Delegate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case savePhoto(UIImage)
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.cameraService) var cameraService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.timer, action: /Action.timer) {
            TimerFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

            // MARK: View Life Cycle

            case .onAppear:
                return .run { send in
                    await cameraService.start()

                    let imageStream = cameraService.previewStream()
                        .map { $0.image }

                    for await image in imageStream {
                        Task { @MainActor in
                            send(.viewFinderUpdate(image))
                        }
                    }
                }

            // MARK: - Image

            case let .viewFinderUpdate(image):
                state.viewFinderImage = image
                return .none

            case .flipImageRemove:
                state.flipImage = nil
                return .none

            case let .completeTakePhoto(image):
                state.isCompleted = true
                state.resultImage = image
                return .none

            case .flipDegreeUpdate:
                state.flipDegree += 180
                return .none

            // MARK: - Camera Tap

            case .shutterTapped:
                return .run { send in
                    let resultImage = await cameraService.takePhoto()
                    await send(.completeTakePhoto(resultImage))
                }

            case .switchButtonTapped:
                state.flipImage = state.viewFinderImage
                state.viewFinderImage = nil

                return .run { send in
                    await cameraService.switchCaptureDevice()
                    await send(.flipImageRemove)
                }

            case .cancelButtonTapped:
                cameraService.stop()
                return .run { _ in await self.dismiss() }

                // MARK: Tap - Photo Tap

            case .reTakeButtonTapped:
                state.isCompleted = false
                return .none

            case .uploadButtonTapped:
                // 이미지 업로드
                return .run { _ in await self.dismiss() }

                // MARK: - Timer

            case .timer:
                return .none

                // MARK: - Delegate

            case .delegate:
                return .none
            }
        }
    }
}
