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
                VStack(spacing: 0) {
                    Spacer()
                    
                    description(viewStore: viewStore)
                    
                    timer(viewStore: viewStore)
                    
                    viewFinderView(viewStore: viewStore)
                    
                    buttonsView(viewStore: viewStore)
                }
                .background(Color.black)
                
                if viewStore.isTimeOver {
                    timeOverView(viewStore: viewStore)
                }
                
                if viewStore.isAlertPresented {
                    BaggleAlert(
                        isPresented: Binding(
                            get: { viewStore.isAlertPresented },
                            set: { viewStore.send(.presentAlert($0)) }
                        ),
                        title: "카메라 권한을 설정해주세요.",
                        description: "카메라가 없으면 컨텐츠 이용이 어려워요",
                        alertType: .twobutton,
                        rightButtonTitle: "설정"
                    ) {
                        viewStore.send(.moveToSetting)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

extension CameraView {
    
    // MARK: - Description
    
    private func description(viewStore: CameraFeatureViewStore) -> some View {
        Text("실시간 상황을\n친구들에게 공유하세요!")
            .multilineTextAlignment(.center)
            .fontWithLineSpacing(fontType: .subTitle)
            .fontWeight(.medium)
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
            if viewStore.isCompleted {
                resultPhotoView(viewStore: viewStore)
            } else {
                cameraPreview(viewStore: viewStore)
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
            if viewStore.isCompleted {
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
    
    // MARK: - 시간 초과
    
    private func timeOverView(viewStore: CameraFeatureViewStore) -> some View {
        ZStack {
            ShadeView(
                isPresented: viewStore.binding(
                    get: \.isTimeOver,
                    send: { CameraFeature.Action.isTimeOverChanged($0) }
                )
            )
            
            Text("시간이 초과되었습니다.")
                .font(.Baggle.subTitle)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(.black)
                .cornerRadius(12)
        }
        .animation(.easeInOut(duration: 0.2), value: viewStore.isTimeOver)
        .onTapGesture {
            viewStore.send(.isTimeOverChanged(false))
        }
    }
}
