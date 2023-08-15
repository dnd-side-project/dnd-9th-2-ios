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

        // Alert
        @PresentationState var alert: AlertState<Action.Alert>?
        
        // Timer
        var timer: TimerFeature.State
        var isTimeOver: Bool = false
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
        case isTimeOverChanged(Bool)

        // Alert
        case presentAlert
        case alert(PresentationAction<Alert>)
        enum Alert: Equatable {
            case primaryButtonTapped
            case alertCancelTapped
        }
        
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
                    let cameraStartStatus = await cameraService.start()

                    switch cameraStartStatus {
                    case .success:
                        let imageStream = cameraService.previewStream()
                            .map { $0.image }

                        for await image in imageStream {
                            Task { @MainActor in
                                send(.viewFinderUpdate(image))
                            }
                        }
                    case .deniedAuthorization:
                        await send(.presentAlert)
                    case .error:
                        print("error")
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
                    let cameraTakePhotoStatus = await cameraService.takePhoto()
                    
                    switch cameraTakePhotoStatus {
                    case .success(let resultImage):
                        await send(.completeTakePhoto(resultImage))
                    case .error:
                        print("사진 촬영 error")
                    }
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
                
                // MARK: - Alert
            case .presentAlert:
                state.alert = AlertState(title: {
                    TextState("카메라 권한이 필요해요")
                }, actions: {
                    ButtonState(role: .cancel, action: .alertCancelTapped) {
                        TextState("취소")
                    }
                    
                    ButtonState(role: .none, action: .primaryButtonTapped) {
                        TextState("설정")
                    }
                }, message: {
                    TextState("컨텐츠를 이용하려면 카메라를 허용 해주세요")
                })
                return .none
                
            case .alert(.presented(.primaryButtonTapped)):
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
                return .none
                
            case .alert(.presented(.alertCancelTapped)):
                return .run { _ in await self.dismiss() }
                
            case .alert:
                return .none

                // MARK: - Timer

            case .timer(.timerOver):
                return .run { send in await send(.isTimeOverChanged(true)) }

            case .timer:
                return .none

            case let .isTimeOverChanged(isTimeOver):
                state.isTimeOver = isTimeOver
                return isTimeOver ? .none : .run { _ in await self.dismiss() }
                
                // MARK: - Delegate

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}
