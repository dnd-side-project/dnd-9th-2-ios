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
            
            ZStack {
                
                if viewStore.isUploading {
                    LoadingView()
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    description(viewStore: viewStore)
                    
                    timer(viewStore: viewStore)
                    
                    viewFinderView(viewStore: viewStore)
                    
                    buttonsView(viewStore: viewStore)
                }
                .background(Color.black)
                
                if viewStore.isTimeOver {
                    DescriptionView(
                        isPresented: viewStore.binding(
                            get: \.isTimeOver,
                            send: { CameraFeature.Action.isTimeOverChanged($0) }
                        ),
                        text: "시간이 초과되었습니다"
                    )
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .baggleAlert(
                isPresented: viewStore.binding(
                    get: { $0.isAlertPresented },
                    send: { CameraFeature.Action.presentAlert($0) }
                ),
                alertType: viewStore.alertType,
                action: { viewStore.send(.alertButtonTapped) }
            )
            .alert(
                store: self.store.scope(
                    state: \.$alert,
                    action: { .systemAlert($0) }
                )
            )
        }
    }
}

extension CameraView {
    
    // MARK: - Description
    
    private func description(viewStore: CameraFeatureViewStore) -> some View {
        Text("실시간 상황을\n친구들에게 공유하세요!")
            .multilineTextAlignment(.center)
            .fontWithLineSpacing(fontType: .subTitle1)
            .foregroundColor(.white)
    }
    
    // MARK: - Timer
    
    private func timer(viewStore: CameraFeatureViewStore) -> some View {
        LargeTimerView(
            store: self.store.scope(
                state: \.timer,
                action: CameraFeature.Action.timer
            )
        )
        .padding(.top, 12)
    }
    
    // MARK: - ViewFinder
    
    private func viewFinderView(viewStore: CameraFeatureViewStore) -> some View {
        ZStack {
            switch viewStore.cameraViewStatus {
            case .camera:
                cameraPreview(viewStore: viewStore)
            case .result:
                resultPhotoView(viewStore: viewStore)
            }
        }
        .frame(width: viewFinderWidth, height: viewFinderHeight)
        .clipped()
        .background(Color.gray2)
        .padding(.top, 32)
    }
    
    private func cameraPreview(viewStore: CameraFeatureViewStore) -> some View {
        ZStack {
            if let image = viewStore.state.viewFinderImage {
                image
                    .resizable()
            } else {
                ProgressView()
            }
            
            if let flipImage = viewStore.state.flipImage {
                flipImage
                    .resizable()
                    .blur(radius: 8, opaque: true)
            }
        }
        .scaledToFill()
        .rotation3DEffect(.degrees(viewStore.state.flipDegree), axis: (x: 0, y: 1, z: 0))
    }
    
    private func resultPhotoView(viewStore: CameraFeatureViewStore) -> some View {
        ZStack {
            if let resultImage = viewStore.state.resultImage {
                Image(uiImage: resultImage)
                    .resizable()
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
            }
        }
        .scaledToFit()
    }
    
    // MARK: - Buttons View
    
    private func buttonsView(viewStore: CameraFeatureViewStore) -> some View {
        VStack {
            if viewStore.cameraViewStatus == .result {
                photoButtons(viewStore: viewStore)
            } else {
                cameraButtons(viewStore: viewStore)
            }
        }
        .frame(height: 62)
        .padding(.top, 42)
        .padding(.bottom, 64)
    }
    
    private func cameraButtons(viewStore: CameraFeatureViewStore) -> some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            // 왼쪽
            Button {
                viewStore.send(.cancelButtonTapped)
            } label: {
                Text("취소")
                    .font(.Baggle.body1)
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
                    Image.Icon.trans
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                }
                .padding(8)
                .background(Color.gray9)
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
                    .font(.Baggle.body1)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
            }
            
            Spacer()
            
            Button {
                viewStore.send(.uploadButtonTapped)
            } label: {
                Text("사진 업로드")
                    .font(.Baggle.body1)
                    .foregroundColor(.primaryNormal)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
            }
        }
        .font(.system(size: 18).bold())
        .padding(.horizontal, 20)
    }
}
