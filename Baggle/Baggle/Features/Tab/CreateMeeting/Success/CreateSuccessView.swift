//
//  CreateMeetingSuccessView.swift
//  Baggle
//
//  Created by youtak on 2023/07/31.
//

import SwiftUI

import ComposableArchitecture

struct CreateSuccessView: View {

    let store: StoreOf<CreateSuccessFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                
                description

                meetingInfo(
                    title: viewStore.meetingSuccessModel.title,
                    place: viewStore.meetingSuccessModel.place,
                    time: viewStore.meetingSuccessModel.time
                )

                // MARK: - 이미지

                Image.Illustration.invitationCreate
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 237)

                Spacer()

                // MARK: - 버튼

                Button {
                    viewStore.send(.kakaoInviteButtonTapped)
                } label: {
                    Text("카카오톡으로 초대장 보내기")
                }
                .buttonStyle(BagglePrimaryStyle())

                Button {
                    viewStore.send(.sendLaterButtonTapped)
                } label: {
                    Text("나중에 보내기")
                        .font(.Baggle.body3)
                        .foregroundColor(.gray5)
                }
                .padding()
            }
            .padding(.horizontal)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

extension CreateSuccessView {
    
    // MARK: - 설명

    private var description: some View {
        VStack {
            Text("약속이 만들어졌어요!")
                .font(.Baggle.subTitle1)
                .foregroundColor(.primaryNormal)
                .padding(.vertical, 8)

            VStack(spacing: 6) {
                Text("카톡으로 친구들에게 초대장을 보내고")

                Text("특별한 추억을 만들어보세요")
            }
            .font(.Baggle.body2)
            .foregroundColor(Color.gray)
        }
        .padding(.top, 44) // 툴바 높이
        .padding(.top, 8)
    }
    
    // MARK: - 모임 설명

    @ViewBuilder
    private func meetingInfo(title: String, place: String, time: String) -> some View {

        HStack {
            VStack(alignment: .leading, spacing: 12) {

                HStack(spacing: 4) {
                    Text("📌")
                    
                    Text(title)
                }
                .font(.Baggle.body1)
                .foregroundColor(.gray11)

                VStack(alignment: .leading, spacing: 8) {

                    Text(
                        attributedColorString(
                            str: "장소  |  \(place)",
                            targetStr: "장소  |",
                            color: .gray9,
                            targetColor: .gray6
                        )
                    )
                    .font(.Baggle.description2)

                    Text(
                        attributedColorString(
                            str: "시간  |  \(time)",
                            targetStr: "시간  |",
                            color: .gray9,
                            targetColor: .gray6
                        )
                    )
                    .font(.Baggle.description2)
                }
            }
            .padding(.vertical, 28)
            .padding(.horizontal, 20)

            Spacer()
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.blue, lineWidth: 1)
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
    }
}

struct CreateSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSuccessView(
            store: Store(
                initialState: CreateSuccessFeature.State(
                    meetingSuccessModel: MeetingSuccessModel(
                        id: 10,
                        title: "모임 생성 성공 테스트",
                        place: "광화문역 213번 추구",
                        time: "2023년 10월 25일 15:30"
                    )
                ),
                reducer: CreateSuccessFeature()
            )
        )
    }
}
