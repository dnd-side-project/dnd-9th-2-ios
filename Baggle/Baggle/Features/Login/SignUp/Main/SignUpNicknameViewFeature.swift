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
        var disableDismissAnimation: Bool = false

        // MARK: - 이미지
        var imageState: AlbumImageState = .empty
        var imageSelection: PhotosPickerItem?

        // MARK: - Child State

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

        // MARK: - Child Action

        case path(StackAction<SignUpSuccessFeature.State, SignUpSuccessFeature.Action>)

        // MARK: - Delegate

        case delegate(Delegate)

        enum Delegate: Equatable {
            case successSignUp
        }
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {

        Reduce { state, action in

            switch action {

                // MARK: - Button Tapped

            case .nextButtonTapped:
                state.disableDismissAnimation = false // 화면 전환 애니메이션 활성화

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
