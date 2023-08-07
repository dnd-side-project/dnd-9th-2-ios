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

                // MARK: - 설명

                VStack {
                    Text("약속이 만들어졌어요!")
                        .font(.title)
                        .padding(.vertical, 8)

                    VStack(spacing: 6) {
                        Text("카톡으로 친구들에게 초대장을 보내고")

                        Text("특별한 추억을 만들어보세요")
                    }
                    .foregroundColor(Color.gray)
                }
                .padding(.top, 44) // 툴바 높이
                .padding(.top, 8)

                // MARK: - 모임 설명

                HStack {
                    VStack(alignment: .leading, spacing: 12) {

                        Text("수빈님네 집들이")
                            .font(.title3)

                        VStack(alignment: .leading, spacing: 8) {

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
                                    str: "시간  |  2023년 10월 25일 15:30",
                                    targetStr: "시간  |",
                                    color: .black,
                                    targetColor: .gray8C
                                )
                            )
                            .font(.system(size: 14))
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

                // MARK: - 이미지

                Image(systemName: "envelope")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

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
                        .foregroundColor(Color.gray)
                }
                .padding()
            }
            .padding(.horizontal)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct CreateMeetingSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSuccessView(
            store: Store(
                initialState: CreateSuccessFeature.State(),
                reducer: CreateSuccessFeature()
            )
        )
    }
}
