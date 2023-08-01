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

        // MARK: - View

        var disableDismissAnimation: Bool = false
        var isLoading: Bool = false

        // MARK: - 이미지

        var imageState: AlbumImageState = .empty
        var imageSelection: PhotosPickerItem?

        // MARK: - 닉네임 TextField

        var nickNameTextFieldState = BaggleTextFeature.State(
            maxCount: 8,
            textFieldState: .inactive
        )

        // MARK: - Child State

        var path = StackState<SignUpSuccessFeature.State>()
    }

    enum Action: Equatable {

        // MARK: - Button Tapped

        case nextButtonTapped
        case cancelButtonTapped

        // MARK: - Screen Move

        case moveToSignUpSuccess
        case moveToHome

        // MARK: - Image

        case imageChanged(PhotosPickerItem?)
        case imageLoading
        case successImageChange(Image)
        case failImageChange

        // MARK: - Nickname

        case textFieldAction(BaggleTextFeature.Action)

        // MARK: - Network

        case requestSignUp(String)
        case networkLoading(Bool)

        // MARK: - Child Action

        case path(StackAction<SignUpSuccessFeature.State, SignUpSuccessFeature.Action>)

        // MARK: - Delegate

        case delegate(Delegate)

        enum Delegate: Equatable {
            case successSignUp
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

                if nicknameValidator.isValidate(nickname) {
                    return .run { send in
                        await send(.networkLoading(true))
                        await send(.requestSignUp(nickname))
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

                // MARK: - Screen Move

            case .moveToSignUpSuccess:
                state.path.append(SignUpSuccessFeature.State())
                return .none

            case .moveToHome:
                return .run { send in
                    await send(.delegate(.successSignUp))
                    await self.dismiss()
                }

                // MARK: - Image

            case let .imageChanged(photoPickerItem):
                return .run { send in
                    await send(.imageLoading)

                    if let profileImage = try? await photoPickerItem?.loadTransferable(
                        type: ProfileImageModel.self
                    ) {
                        await send(.successImageChange(profileImage.image))
                    } else {
                        await send(.failImageChange)
                    }
                }

            case .imageLoading:
                state.imageState = .loading
                return .none

            case let .successImageChange(image):
                state.imageState = .success(image)
                return .none

            case .failImageChange:
                state.imageState = .failure
                return .none

                // MARK: - Nickname TextField

            case .textFieldAction:
                return .none

                // MARK: - Network

            case let .requestSignUp(nickname):
                return .run { send in
                    let result = await signUpService.signUp(nickname)
                    await send(.networkLoading(false))

                    switch result {
                    case .success:
                        await send(.moveToSignUpSuccess)
                    case .nicknameDuplicated:
                        await send(.textFieldAction(.changeState(.invalid("중복되는 닉네임이 있습니다."))))
                    case .fail:
                        await send(.textFieldAction(.changeState(.invalid("네트워크 에러입니다."))))
                        // Alert으로 변경 필요
                    }
                }

            case let .networkLoading(isLoading):
                state.isLoading = isLoading
                return .none

                // MARK: - Child Action

            case let .path(.element(id: id, action: .delegate(.moveToHome))):
                state.disableDismissAnimation = true // 회원 가입 완료하고 홈 화면 이동시 화면 전환 애니메이션 비활성화

                state.path.pop(from: id)
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
            SignUpSuccessFeature()
        }
    }
}
