//
//  CameraView.swift
//  Baggle
//
//  Created by youtak on 2023/08/05.
//

import SwiftUI

import ComposableArchitecture

struct CameraView: View {

    typealias CameraFeatureViewStore = ViewStore<CameraFeature.State, CameraFeature.Action>

    let store: StoreOf<CameraFeature>
    let flipAnimationDuration: Double = 0.5
    let viewFinderWidth = UIScreen.main.bounds.width
    let viewFinderHeight = UIScreen.main.bounds.width * CameraSetting.ratio

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack(spacing: 0) {
                Spacer()

                description(viewStore: viewStore)

                timer(viewStore: viewStore)

                viewFinderView(viewStore: viewStore)

                buttonsView(viewStore: viewStore)
            }
            .background(Color.black)
            .onAppear {
                viewStore.send(.onAppear)
                print(viewStore)
            }
        }
    }
}

extension CameraView {

    // MARK: - Description

    private func description(viewStore: CameraFeatureViewStore) -> some View {
        Text("실시간 상황을\n친구들에게 공유하세요!")
            .multilineTextAlignment(.center)
            .lineSpacing(1.4)
            .font(.system(size: 22))
            .fontWeight(.medium)
            .foregroundColor(.white)
    }

    // MARK: - Timer

    private func timer(viewStore: CameraFeatureViewStore) -> some View {
        Text("03:39")
            .padding(.vertical, 10)
            .padding(.horizontal, 24)
            .foregroundColor(Color.black)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.top, 12)
    }

    // MARK: - ViewFinder

    private func viewFinderView(viewStore: CameraFeatureViewStore) -> some View {
        ZStack {
            if viewStore.isCompleted {
                if let image = viewStore.state.resultImage {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                }
            } else {
                if let image = viewStore.state.viewFinderImage {
                    image
                        .resizable()
                        .scaledToFit()
                }

                if let flipImage = viewStore.state.flipImage {
                    flipImage
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 8, opaque: true)
                }
            }
        }
        .frame(width: viewFinderWidth, height: viewFinderHeight)
        .background(Color.gray)
        .rotation3DEffect(.degrees(viewStore.state.flipDegree), axis: (x: 0, y: 1, z: 0))
        .padding(.top, 32)
    }

    // MARK: - Buttons View

    private func buttonsView(viewStore: CameraFeatureViewStore) -> some View {
        VStack {
            if viewStore.isCompleted {
                photoButtons(viewStore: viewStore)
            } else {
                cameraButtons(viewStore: viewStore)
            }
        }
        .frame(height: 62)
        .padding(.top, 42)
        .padding(.bottom, 90)
    }

    private func cameraButtons(viewStore: CameraFeatureViewStore) -> some View {

        HStack(alignment: .center, spacing: 0) {

            // 왼쪽
            Button {
                viewStore.send(.cancelButtonTapped)
            } label: {
                Text("취소")
                    .foregroundColor(Color.white)
                    .padding(.vertical, 12)
            }
            .frame(width: 60)

            Spacer()

            // 가운데

            HStack {
                Button {
                    viewStore.send(.shutterTapped)
                } label: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }

            Spacer()

            // 오른쪽

            Button {
                viewStore.send(.switchButtonTapped)
                viewStore.send(
                    .flipDegreeUpdate,
                    animation: Animation.linear(duration: flipAnimationDuration)
                )
            } label: {
                ZStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .resizable()
                        .scaledToFit()
                        .tint(.white)
                        .frame(width: 24, height: 24)
                }
                .padding(8)
                .background(Color.gray)
                .cornerRadius(50)
            }
            .frame(width: 60)
        }
        .padding(.horizontal, 56)
    }

    private func photoButtons(viewStore: CameraFeatureViewStore) -> some View {
        HStack {
            Button {
                viewStore.send(.reTakeButtonTapped)
            } label: {
                Text("다시 찍기")
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
            }

            Spacer()

            Button {
                viewStore.send(.uploadButtonTapped)
            } label: {
                Text("사진 업로드")
                    .foregroundColor(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
            }
        }
        .font(.system(size: 18).bold())
        .padding(.horizontal, 20)
    }
}
