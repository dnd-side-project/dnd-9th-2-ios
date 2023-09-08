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
        
        // MARK: - User
        
        var memberID: Int
        
        // MARK: - Image
        
        var viewFinderImage: Image?
        var resultImage: UIImage?

        var flipImage: Image?
        var isFlipped: Bool = false
        var flipDegree: Double = 0.0

        // MARK: - Status
        var cameraViewStatus: CameraViewStatus = .camera
        var isUploading: Bool = false

        // MARK: - System Alert - 권한 요청용
        @PresentationState var alert: AlertState<Action.SystemAlert>?
        
        // MARK: - Baggle Alert
        var isAlertPresented: Bool = false
        var alertType: AlertCameraType?
        
        // Timer
        var timer: TimerFeature.State
        var isTimeOver: Bool = false
    }

    enum Action: Equatable {

        case onAppear

        // MARK: - Image

        case viewFinderUpdate(Image?)
        case flipImageRemove
        case flipDegreeUpdate
        case completeTakePhoto(UIImage?)

        // MARK: - Tap - Camera
        
        case shutterTapped
        case switchButtonTapped
        case cancelButtonTapped

        // MARK: - Tap - Photo
        
        case reTakeButtonTapped
        case uploadButtonTapped

        // MARK: - Network
        
        case handleFeedPhotoResult(FeedPhotoResult)
        
        // MARK: - Timer
        
        case timer(TimerFeature.Action)
        case isTimeOverChanged(Bool)

        // MARK: - Alert - System
        
        case presentSystemAlert
        case systemAlert(PresentationAction<SystemAlert>)
        enum SystemAlert: Equatable {
            case primaryButtonTapped
            case alertCancelTapped
        }
        
        // MARK: - Alert - Baggle
        
        case presentAlert(Bool)
        case alertTypeChanged(AlertCameraType)
        case alertButtonTapped
        
        // MARK: - Delegate
        
        case delegate(Delegate)

        enum Delegate: Equatable {
            case savePhoto(UIImage)
            case uploadSuccess(feed: Feed)
            case moveToLogin
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.cameraService) var cameraService
    @Dependency(\.feedPhotoService) var feedPhotoService

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
                    let cameraStartResult = await cameraService.start()

                    switch cameraStartResult {
                    case .success:

                        let imageStream = cameraService.previewStream()
                            .map { $0.image }

                        for await image in imageStream {
                            Task { @MainActor in
                                send(.viewFinderUpdate(image))
                            }
                        }
                    case .deniedAuthorization:
                        await send(.presentSystemAlert)
                    case .error:
                        await send(.alertTypeChanged(.cameraConfigureError))
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
                state.cameraViewStatus = .result
                state.resultImage = image
                return .none

            case .flipDegreeUpdate:
                state.flipDegree += 180
                return .none

            // MARK: - Camera Tap

            case .shutterTapped:
                #if targetEnvironment(simulator)
                return .run { send in
                    await send(.completeTakePhoto(UIImage(systemName: "star.fill")))
                }
                #else
                return .run { send in
                    let cameraTakePhotoResult = await cameraService.takePhoto()
                    
                    switch cameraTakePhotoResult {
                    case .success(let resultImage):
                        await send(.completeTakePhoto(resultImage))
                    case .error:
                        print("사진 촬영 error")
                    }
                }
                #endif

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
                state.cameraViewStatus = .camera
                return .none

            case .uploadButtonTapped:
                state.isUploading = true
                
                guard let resultImage = state.resultImage else {
                    // 이미지 없음
                    return .run { send in await send(.alertTypeChanged(.noResultImage))}
                }
                
                guard let feedPhotoRequestModel = FeedPhotoRequestModel(
                    memberID: state.memberID,
                    time: Date(),
                    feedImage: resultImage
                ) else {
                    return .run { send in await send(.alertTypeChanged(.compressionError))}
                }
                
                return .run { send in
                    let result = await feedPhotoService.upload(feedPhotoRequestModel)
                    await send(.handleFeedPhotoResult(result))
                }
                
                // MARK: - Network
                
            case .handleFeedPhotoResult(let result):
                state.isUploading = false
                switch result {
                case .success(let feed):
                    return .run { send in
                        await send(.delegate(.uploadSuccess(feed: feed)))
                        await self.dismiss()
                    }
                case .invalidAuthorizationTime:
                    return .run { send in await send(.alertTypeChanged(.invalidAuthorizationTime))}
                case .notFound:
                    return .run { send in await send(.alertTypeChanged(.notFound))}
                case .alreadyUpload:
                    return .run { send in await send(.alertTypeChanged(.alreadyUpload))}
                case .networkError(let description):
                    return .run { send in await send(.alertTypeChanged(.networkError(description)))}
                case .userError:
                    state.alertType = .userError
                    return .run { send in await send(.alertTypeChanged(.userError))}
                }
                
                // MARK: - System Alert

            case .presentSystemAlert:
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
                
            case .systemAlert(.presented(.primaryButtonTapped)):
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
                return .none
                
            case .systemAlert(.presented(.alertCancelTapped)):
                return .run { _ in await self.dismiss() }
                
            case .systemAlert:
                return .none
                
                // MARK: - Baggle Alert
            case .presentAlert(let isPresented):
                if !isPresented {
                    state.alertType = nil
                }
                state.isAlertPresented = isPresented
                return .none
            
            case .alertTypeChanged(let alertType):
                state.alertType = alertType
                state.isAlertPresented = true
                return .none
            
            case .alertButtonTapped:
                guard let alertType = state.alertType else {
                    return .none
                }
                state.alertType = nil
                
                switch alertType {
                case .cameraConfigureError, .compressionError: // 카메라 에러
                    return .run { _ in await self.dismiss() }
                case .notFound, .networkError, .invalidAuthorizationTime, .alreadyUpload: // 네트워크 에러
                    return .run { _ in await self.dismiss() }
                case .noResultImage:
                    state.resultImage = nil
                    state.cameraViewStatus = .camera
                    return .none
                case .userError:
                    return .run { send in await send(.delegate(.moveToLogin))}
                }

                // MARK: - Timer

            case .timer(.timerOver):
                return .run { send in await send(.isTimeOverChanged(true)) }

            case .timer:
                return .none

            case let .isTimeOverChanged(isTimeOver):
                if !state.isUploading {
                    state.isTimeOver = isTimeOver
                }
                return isTimeOver ? .none : .run { _ in await self.dismiss() }
                
                // MARK: - Delegate

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.systemAlert)
    }
}
