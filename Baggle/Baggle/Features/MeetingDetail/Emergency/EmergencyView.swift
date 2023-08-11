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

            GeometryReader { _ in

                // MARK: - Background

                if viewStore.isEmergency {
                    Image.Background.home
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
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

                    // MARK: - Content

                    if viewStore.isEmergency {
                        afterEmergency(viewStore: viewStore)
                    } else {
                        beforeEmergency(viewStore: viewStore)
                    }
                }
            }
            .animation(.easeIn(duration: 0.3), value: viewStore.isEmergency)
        }
    }
}

extension EmergencyView {

    private func beforeEmergency(viewStore: EmergencyViewStore) -> some View {
        VStack {

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

            VStack(spacing: 30) {
                BubbleView(
                    size: .medium,
                    color: .secondary,
                    text: "긴급 버튼을 눌러보세요!"
                )

                Button {
                    viewStore.send(.emergencyButtonTapped)
                } label: {
                    Image(systemName: "light.beacon.max")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220)
                }
            }
            .padding(.bottom, 120)
        }
    }

    private func afterEmergency(viewStore: EmergencyViewStore) -> some View {
        ZStack(alignment: .bottom) {
            VStack {

                // Temp
                VStack(spacing: 0) {
                    Text("Warning")
                        .font(.title)
                }
                .frame(width: 310, height: 96)
                .background(Color.yellow)

                LargeTimerView(
                    store: self.store.scope(
                        state: \.timerState,
                        action: EmergencyFeature.Action.timerAction
                    )
                )
                .padding(.top, 15)

                Spacer()

                Image(systemName: "light.beacon.max.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .scaledToFit()
                    .frame(width: 220)
                    .padding(.bottom, 120)
            }

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
        }
    }
}

struct EmergencyView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyView(
            store: Store(
                initialState: EmergencyFeature.State(),
                reducer: EmergencyFeature()
            )
        )
    }
}
