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

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            GeometryReader { geometry in

                VStack {

                    Spacer()

                    viewFinderView(viewStore: viewStore)

                    buttonsView(viewStore: viewStore)
                }
                .background(Color.black)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewStore.send(.cancelButtonTapped)
                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.viewWillAppear)
            }
        }
    }

    private func viewFinderView(viewStore: CameraFeatureViewStore) -> some View {
        GeometryReader { geometry in
            ZStack {
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
            .frame(width: geometry.size.width, height: geometry.size.width * CameraSetting.ratio)
            .background(Color.clear)
            .rotation3DEffect(.degrees(viewStore.state.flipDegree), axis: (x: 0, y: 1, z: 0))
        }
    }

    private func buttonsView(viewStore: CameraFeatureViewStore) -> some View {

        HStack() {

            HStack {
                Spacer()
                Spacer()
            }

            HStack {
                Spacer()

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

                Spacer()
            }

            HStack {
                Spacer()

                Button {
                    viewStore.send(.switchButtonTapped)
                    viewStore.send(
                        .flipDegreeUpdate,
                        animation: Animation.linear(duration: flipAnimationDuration)
                    )
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .resizable()
                        .scaledToFit()
                        .tint(.white)
                        .frame(width: 40, height: 40)
                }

                Spacer()
            }
        }
        .padding()
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(
            store: Store(
                initialState: CameraFeature.State(),
                reducer: CameraFeature()
            )
        )
    }
}
