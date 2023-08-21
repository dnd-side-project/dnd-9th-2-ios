//
//  EmergencyView.swift
//  Baggle
//
//  Created by youtak on 2023/08/07.
//

import SwiftUI

import ComposableArchitecture

struct EmergencyView: View {
    
    typealias EmergencyViewStore = ViewStore<EmergencyFeature.State, EmergencyFeature.Action>
    
    let store: StoreOf<EmergencyFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            ZStack {
                GeometryReader { proxy in

                    // MARK: - Content
                    
                    if viewStore.isFetched {
                        afterEmergency(viewStore: viewStore, proxy: proxy)
                        if viewStore.isEmergency {
                            successEmergency(viewStore: viewStore, proxy: proxy)
                        }
                    } else {
                        beforeEmergency(viewStore: viewStore, proxy: proxy)
                    }
                    
                    VStack(spacing: 0) {
                        
                        // MARK: - Status Bar
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                viewStore.send(.closeButtonTapped)
                            } label: {
                                Image.Icon.close
                                    .frame(width: 24, height: 24)
                                    .padding(10)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
                
                if viewStore.isTimeExpired {
                    DescriptionView(
                        isPresented: Binding(
                            get: { viewStore.isTimeExpired },
                            set: { viewStore.send(.timeExpiredChanged($0))}
                        ),
                        text: "시간 경과로 긴급 버튼이 자동으로 호출됐습니다"
                    )
                }
                
                if let alertType = viewStore.alertType {
                    BaggleAlertOneButton(
                        isPresented: Binding(
                            get: { viewStore.alertType != nil },
                            set: { viewStore.send(.presentBaggleAlert($0))}
                        ),
                        title: alertType.title,
                        description: alertType.description,
                        buttonTitle: alertType.buttonTitle) {
                            viewStore.send(.alertButtonTapped)
                        }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }
}

extension EmergencyView {
    
    private func beforeEmergency(viewStore: EmergencyViewStore, proxy: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
            
            Image.Emergency.buttonOff
                .resizable()
                .scaledToFit()
                .frame(width: proxy.size.width * 0.586)
                .offset(y: -proxy.size.height * 0.155)
                .onTapGesture {
                    viewStore.send(.emergencyButtonTapped)
                }
            
            VStack {
               
                HStack {
                    Spacer()
                    
                    VStack {
                        Text(
                            attributedColorString(
                                str: "긴급버튼을 눌러\n참여자를 호출하세요",
                                targetStr: "긴급버튼",
                                color: .gray11,
                                targetColor: .baggleRed
                            )
                        )
                        .font(.Baggle.title)
                        .padding(.vertical, 8)
                        
                        Text("긴급버튼을 누르면 5분 내로 현재 상황을\n인증해야해요!")
                            .font(.Baggle.body2)
                            .foregroundColor(.gray7)
                    }
                    .padding(.top, 8)
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.top, 56)
        }
    }
    
    private func afterEmergency(viewStore: EmergencyViewStore, proxy: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
            
            LottieView(lottieType: .button)
                .ignoresSafeArea()
            
            Image.Emergency.buttonOn
                .resizable()
                .scaledToFit()
                .frame(width: proxy.size.width * 0.586)
                .offset(y: -proxy.size.height * 0.155)
        }
    }
    
    private func successEmergency(
        viewStore: EmergencyViewStore,
        proxy: GeometryProxy
    ) -> some View {
        VStack {
            
            Spacer()
                .frame(maxHeight: proxy.size.height * 0.23)
            
            LargeTimerView(
                store: self.store.scope(
                    state: \.timer,
                    action: EmergencyFeature.Action.timerAction
                ),
                color: .black
            )
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    viewStore.send(.cameraButtonTapped)
                } label: {
                    HStack(spacing: 8) {
                        Image.Icon.cameraColor
                        
                        Text("사진 인증하기")
                    }
                }
                .buttonStyle(BaggleSecondaryStyle())
                .padding(.bottom, 16)
                
                Spacer()
            }
        }
        .transition(.opacity.animation(.easeIn(duration: 0.3)))
    }
}

struct EmergencyView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyView(
            store: Store(
                initialState: EmergencyFeature.State(
                    memberID: 100,
                    remainTimeUntilExpired: 1000
                ),
                reducer: EmergencyFeature()
            )
        )
    }
}
