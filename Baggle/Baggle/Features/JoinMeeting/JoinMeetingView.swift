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
            VStack(alignment: .center, spacing: 0) {
                createDescription()
                    .padding(.top, 46)
                
                createMeetingInfo()
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
        }
    }
}

extension JoinMeetingView {
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
    
    func createMeetingInfo() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Text("📌")
                    
                    Text("수빈님네 집들이")
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(
                        attributedColorString(
                            str: "장소  |  유탁님 없는 잠실",
                            targetStr: "장소  |",
                            color: .black,
                            targetColor: .gray8C
                        )
                    )
                    .font(.system(size: 14))
                    
                    Text(
                        attributedColorString(
                            str: "시간  |  2023년 10월 23일 15:30",
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
    
    func createButton(
        viewStore: ViewStore<JoinMeetingFeature.State, JoinMeetingFeature.Action>
    ) -> some View {
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
