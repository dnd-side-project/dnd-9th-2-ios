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

        var isFlipped: Bool = false
        var flipDegree: Double = 0.0 {
            didSet(oldValue) {
                print(oldValue)
            }
        }
        var flipImage: Image?
    }

    enum Action: Equatable {
        case viewWillAppear

        case viewFinderUpdate(Image?)
        case flipImageRemove

        case shutterTapped
        case switchButtonTapped
        case cancelButtonTapped

        case flipDegreeUpdate
        case delegate(Delegate)

        enum Delegate: Equatable {
            case savePhoto(Image)
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.cameraService) var cameraService

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in

            switch action {

            // MARK: View Life Cycle

            case .viewWillAppear:

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

            // MARK: - Button Tapped

            case .shutterTapped:
                return .run { send in
                    let resultImage = await cameraService.takePhoto()
                    // 결과 View
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

            case .flipDegreeUpdate:
                state.flipDegree += 180
                return .none

            // MARK: - Delegate

            case .delegate:
                return .none
            }
        }
    }
}
