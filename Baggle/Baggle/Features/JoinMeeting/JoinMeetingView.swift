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
                if case let .enable(joinMeeting) = viewStore.joinMeeingStatus {
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
                } else {
                    if let alertType = viewStore.alertType {
                        baggleAlert(viewStore: viewStore, alertType: alertType)
                    }
                }
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

extension JoinMeetingView {
    typealias Viewstore = ViewStore<JoinMeetingFeature.State, JoinMeetingFeature.Action>
    
    func createDescription() -> some View {
        VStack {
            Text("약속 초대장이 도착했어요!\n참여하시겠어요?")
                .multilineTextAlignment(.center)
                .font(.Baggle.subTitle1)
                .foregroundColor(.primaryNormal)
                .padding(.vertical, 8)
            
            Text("초대장을 확인하고 약속에 참여해보세요.")
                .font(.Baggle.body2)
                .foregroundColor(.gray6)
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
                .font(.Baggle.body1)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(
                        attributedColorString(
                            str: "장소  |  \(data.place)",
                            targetStr: "장소  |",
                            color: .gray9,
                            targetColor: .gray6
                        )
                    )
                    
                    Text(
                        attributedColorString(
                            str: "시간  |  \(data.date) \(data.time)",
                            targetStr: "시간  |",
                            color: .gray9,
                            targetColor: .gray6)
                    )
                }
                .font(.Baggle.description2)
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
                    .font(.Baggle.body3)
                    .foregroundColor(.gray5)
                    .frame(width: screenSize.width-40, height: 54)
            }
        }
    }
    
    func baggleAlert(viewStore: Viewstore, alertType: AlertType) -> some View {
        BaggleAlertOneButton(
            isPresented: Binding(
                get: { viewStore.alertType != nil },
                set: { viewStore.send(.presentAlert($0)) }
            ),
            title: alertType.title,
            description: alertType.description,
            buttonTitle: alertType.buttonTitle) {
                viewStore.send(.exitButtonTapped)
            }
    }
}

struct JoinMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        JoinMeetingView(
            store: Store(
                initialState: JoinMeetingFeature.State(
                    meetingId: 100,
                    joinMeeingStatus: .expired(.overlapMeetingTime)),
                reducer: JoinMeetingFeature()
            )
        )
    }
}
