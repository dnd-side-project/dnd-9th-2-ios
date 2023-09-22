//
//  SignUpFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import PhotosUI
import SwiftUI

import ComposableArchitecture

struct SignUpFeature: ReducerProtocol {

    struct State: Equatable {
        
        var loginPlatform: LoginPlatform
        var socialLoginToken: String

        // MARK: - View

        var disableDismissAnimation: Bool = false
        var isLoading: Bool = false
        var keyboardAppear: Bool = false
        var disableButton: Bool = true

        // MARK: - 이미지

        var imageState: AlbumImageState = .empty
        var imageSelection: PhotosPickerItem?
        var selectedImage: Data?

        // MARK: - 닉네임 TextField

        var nickNameTextFieldState = BaggleTextFeature.State(
            maxCount: 8,
            textFieldState: .inactive
        )

        // MARK: - Alert
        
        var isAlertPresented: Bool = false
        var alertType: AlertSignUpType?
        
        // MARK: - Child State

        var path = StackState<Child.State>()
    }

    enum Action: Equatable {

        // MARK: - Button Tapped

        case nextButtonTapped
        case cancelButtonTapped

        case disableButtonChanged

        // MARK: - Screen Move

        case moveToSignUpSuccess
        case moveToHome

        // MARK: - Image

        case imageChanged(PhotosPickerItem?)
        case imageLoading
        case successImageChange(UIImage)
        case failImageChange

        // MARK: - Nickname

        case textFieldAction(BaggleTextFeature.Action)
        case keyboardAppear

        // MARK: - Network

        case requestSignUp(SignUpRequestModel)
        case networkLoading(Bool)

        // MARK: - Alert

        case presentAlert(Bool)
        case alertTypeChanged(AlertSignUpType)
        case alertButtonTapped
        
        // MARK: - Child Action

        case path(StackAction<Child.State, Child.Action>)

        // MARK: - Delegate

        case delegate(Delegate)

        enum Delegate: Equatable {
            case moveToHome
        }
    }

    // MARK: - Child
    
    struct Child: ReducerProtocol {

        enum State: Equatable {
            case signUpSuccess(SignUpSuccessFeature.State)
        }

        enum Action: Equatable {
            case signUpSuccess(SignUpSuccessFeature.Action)
        }

        var body: some ReducerProtocolOf<Self> {
            Scope(state: /State.signUpSuccess, action: /Action.signUpSuccess) {
                SignUpSuccessFeature()
            }
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.nicknameValidator) var nicknameValidator
    @Dependency(\.signUpService) var signUpService

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope

        Scope(state: \.nickNameTextFieldState, action: /Action.textFieldAction) {
            BaggleTextFeature()
        }

        Reduce { state, action in

            switch action {

                // MARK: - Button Tapped

            case .nextButtonTapped:
                state.disableDismissAnimation = false // 화면 전환 애니메이션 활성화
                let nickname = state.nickNameTextFieldState.text
                // platform, fcmToken 값 넣어주기
                let requestModel = SignUpRequestModel(
                    nickname: nickname,
                    profilImageUrl: state.selectedImage,
                    platform: state.loginPlatform,
                    fcmToken: UserDefaultManager.fcmToken ?? ""
                )

                if nicknameValidator.isValidate(nickname) {
                    return .run { send in
                        await send(.networkLoading(true))
                        await send(.requestSignUp(requestModel))
                    }
                } else {
                    return .run { send in
                        await send(.textFieldAction(.changeState(.invalid(
                            "닉네임이 조건에 맞지 않습니다. (한, 영, 숫자, _, -, 2-10자)"
                        ))))
                    }
                }

            case .cancelButtonTapped:
                state.disableDismissAnimation = false // 화면 전환 애니메이션 활성화

                return .run { _ in await self.dismiss() }

            case .disableButtonChanged:
                let textCount = state.nickNameTextFieldState.text.count

                // 실패 시에는 기본이미지로 회원가입
                if textCount < 2 || state.imageState == .loading {
                    state.disableButton = true
                } else {
                    state.disableButton = false
                }
                return .none

                // MARK: - Screen Move

            case .moveToSignUpSuccess:
                state.path.append(
                    .signUpSuccess(
                        SignUpSuccessFeature.State()
                    )
                )
                return .none

            case .moveToHome:
                return .run { send in
                    await send(.delegate(.moveToHome))
                    await self.dismiss()
                }

                // MARK: - Image

            case let .imageChanged(photoPickerItem):
                return .run { send in
                    await send(.imageLoading)
                    
                    if let profileUIImage = try? await photoPickerItem?.loadTransferable(
                        type: ProfileImageModel.self
                    ) {
                        await send(.successImageChange(profileUIImage.image))
                    } else {
                        await send(.failImageChange)
                    }
                    
                    await(send(.keyboardAppear))
                }

            case .imageLoading:
                state.imageState = .loading
                return .run { send in await send(.disableButtonChanged) }

            case let .successImageChange(image):
                state.imageState = .success(Image(uiImage: image))
                state.selectedImage = image.jpegData(
                    compressionQuality: Const.Image.jpegCompression
                )
                return .run { send in await send(.disableButtonChanged) }

            case .failImageChange:
                state.imageState = .failure
                return .run { send in await send(.disableButtonChanged) }

                // MARK: - Nickname TextField

            case .textFieldAction(.isFocused):
                return .run { send in await send(.keyboardAppear) }

            case .textFieldAction(.textChanged):
                return .run { send in await send(.disableButtonChanged) }

            case .textFieldAction:
                return .none

            case .keyboardAppear:
                state.keyboardAppear.toggle()
                return .none

                // MARK: - Network

            case let .requestSignUp(requestModel):
                let token = state.socialLoginToken
                return .run { send in
                    let result = await signUpService.signUp(requestModel, token)
                    await send(.networkLoading(false))

                    switch result {
                    case .success:
                        await send(.moveToSignUpSuccess)
                    case .nicknameDuplicated:
                        await send(.textFieldAction(.changeState(.invalid("중복되는 닉네임이 있습니다."))))
                    case .networkError(let description):
                        await send(.alertTypeChanged(.networkError(description)))
                    case .userError:
                        await send(.alertTypeChanged(.userError))
                    }
                }

            case let .networkLoading(isLoading):
                state.isLoading = isLoading
                return .none

                // MARK: - Alert

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
                case .networkError, .userError:
                    return .none
                }
                
                
                // MARK: - Child Action

            case let .path(.element(id: id, action: .signUpSuccess(.delegate(.moveToNext)))):
                _ = id
                state.disableDismissAnimation = true // 회원 가입 완료하고 홈 화면 이동시 화면 전환 애니메이션 비활성화

                return .run { send in
                    await send(.moveToHome)
                }
                
            case .path:
                return .none

                // MARK: - Delegate

            case .delegate:
                return . none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Child()
        }
    }
}
