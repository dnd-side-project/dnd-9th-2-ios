//
//  JoinMeetingView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct JoinMeetingView: View {

    let store: StoreOf<JoinMeetingFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                switch viewStore.joinMeeingState {
                case .enable(let joinMeeting):
                    VStack(alignment: .center, spacing: 0) {
                        createDescription()
                            .padding(.top, 46)
                        
                        createMeetingInfo(data: joinMeeting)
                            .padding(.top, 26)
                        
                        Spacer()
                        
                        Image.Illustration.invitationReceive
                            .resizable()
                            .scaledToFit()
                            .padding(.leading, 79)
                            .padding(.trailing, 56)
                        
                        Spacer()
                        
                        createButton(viewStore: viewStore)
                            .padding(.bottom, 16)
                    }
                case .expired:
                    baggleAlert(viewStore: viewStore)
                case .joined:
                    Text("이미 참여 중인 방입니다")
                case .loading:
                    Text("참여할 약속 정보를 불러오고 있습니다.")
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

extension JoinMeetingView {
    typealias Viewstore = ViewStore<JoinMeetingFeature.State, JoinMeetingFeature.Action>
    
    func createDescription() -> some View {
        VStack {
            Text("약속 초대장이 도착했어요!\n참여하시겠어요?")
                .multilineTextAlignment(.center)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primaryNormal)
                .padding(.vertical, 8)
            
            Text("초대장을 확인하고 약속에 참여해보세요.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray8C)
        }
        .padding(.top, 8)
    }
    
    func createMeetingInfo(data: JoinMeeting) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Text("📌")
                    
                    Text(data.title)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(
                        attributedColorString(
                            str: "장소  |  \(data.place)",
                            targetStr: "장소  |",
                            color: .black,
                            targetColor: .gray8C
                        )
                    )
                    .font(.system(size: 14))
                    
                    Text(
                        attributedColorString(
                            str: "시간  |  \(data.date) \(data.time)",
                            targetStr: "시간  |",
                            color: .black,
                            targetColor: .gray8C)
                    )
                    .font(.system(size: 14))
                }
            }
            
            Spacer()
        }
        .padding(20)
        .frame(width: screenSize.width - 80)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primaryNormal, lineWidth: 1)
        }
    }
    
    func createButton(viewStore: Viewstore) -> some View {
        VStack(spacing: 0) {
            Button("약속 참여하기") {
                viewStore.send(.joinButtonTapped)
            }
            .buttonStyle(BagglePrimaryStyle())
            
            Button {
                viewStore.send(.exitButtonTapped)
            } label: {
                Text("닫기")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.grayBF)
                    .frame(width: screenSize.width-40, height: 54)
            }
        }
    }
    
    func baggleAlert(viewStore: Viewstore) -> some View {
        BaggleAlert(
            isPresented: Binding(
                get: { viewStore.isAlertPresented },
                set: { _ in viewStore.send(.presentAlert) }),
            title: "이미 만료된 방이에요!",
            description: "약속 1시간 전까지만 입장이 가능해요.",
            alertType: .onebutton,
            rightButtonTitle: "확인") {
                viewStore.send(.exitButtonTapped)
            }
    }
}

struct JoinMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        JoinMeetingView(
            store: Store(
                initialState: JoinMeetingFeature.State(meetingId: 100),
                reducer: JoinMeetingFeature()
            )
        )
    }
}
