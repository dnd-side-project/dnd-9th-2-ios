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

    private let nicknameMaxCount: Int = 8

    struct State: Equatable {
        var disableDismissAnimation: Bool = false

        // MARK: - 이미지

        var imageState: AlbumImageState = .empty
        var imageSelection: PhotosPickerItem?

        // MARK: - 닉네임 TextField

        var nickname: String = ""
        var textfieldState: TextFieldState = .inactive

        // MARK: - Child State

        var loginSuccess: Bool = false
        var path = StackState<SignUpSuccessFeature.State>()
    }

    enum Action: Equatable {

        // MARK: - Button Tapped

        case nextButtonTapped
        case cancelButtonTapped

        // MARK: - Screen Move

        case moveToHome

        // MARK: - Image

        case imageChanged(PhotosPickerItem?)
        case loading
        case successImageChange(Image)
        case failImageChange

        // MARK: - Nickname

        case nicknameChanged(String)
        case textfieldStateChanged

        // MARK: - Child Action

        case loginSuccess
        case path(StackAction<SignUpSuccessFeature.State, SignUpSuccessFeature.Action>)

        // MARK: - Delegate

        case delegate(Delegate)

        enum Delegate: Equatable {
            case successSignUp
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.nicknameValidator) var nicknameValidator

    var body: some ReducerProtocolOf<Self> {

        Reduce { state, action in

            switch action {

                // MARK: - Button Tapped

            case .nextButtonTapped:
                state.disableDismissAnimation = false // 화면 전환 애니메이션 활성화
                if nicknameValidator.isValidate(state.nickname) {
//                    state.loginSuccess = true
                    state.path.append(SignUpSuccessFeature.State())
                } else {
                    state.textfieldState = .invalid("닉네임이 조건에 맞지 않습니다. (한, 영, 숫자, _, -, 2-10자)")
                }

                return .none

            case .cancelButtonTapped:
                state.disableDismissAnimation = false // 화면 전환 애니메이션 활성화

                return .run { _ in await self.dismiss() }

                // MARK: - Screen Move

            case .moveToHome:
                return .run { send in
                    await send(.delegate(.successSignUp))
                    await self.dismiss()
                }

                // MARK: - Image

            case let .imageChanged(photoPickerItem):
                return .run { send in
                    await send(.loading)

                    if let profileImage = try? await photoPickerItem?.loadTransferable(
                        type: ProfileImageModel.self
                    ) {
                        await send(.successImageChange(profileImage.image))
                    } else {
                        await send(.failImageChange)
                    }
                }

            case .loading:
                state.imageState = .loading
                return .none

            case let .successImageChange(image):
                state.imageState = .success(image)
                return .none

            case .failImageChange:
                state.imageState = .failure
                return .none

                // MARK: - Nickname TextField

            case .nicknameChanged(let text):
                state.nickname = text
                if state.nickname.isEmpty {
                    state.textfieldState = .inactive
                } else {
                    state.textfieldState = .active
                }
                return .none

            case .textfieldStateChanged:
                return .none

                // MARK: - Child Action

            case .loginSuccess:
                return .none

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
