//
//  MeetingDetailView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

struct MeetingDetailView: View {

    let store: StoreOf<MeetingDetailFeature>

    @Environment(\.dismiss) private var dismiss

    // 임시 액션시트
    @State var isActionSheetShow: Bool = false

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .top) {
                // navibar
                NaviBarView(naviType: .more) {
                    viewStore.send(.backButtonTapped)
                } rightButtonAction: {
                    isActionSheetShow = true
                }
                .background(.blue.opacity(0.2))

                ScrollView {

                    // header
                    headerView(viewStore: viewStore)

                    memberListView(viewStore: viewStore)
                        .padding(.horizontal, 20)
                        .drawUnderline(spacing: 0,
                                       height: 0.5,
                                       color: .gray.opacity(0.5))

                    if let data = viewStore.meetingData {
                        Text("모임명: \(data.name), 모임 id: \(data.id)")
                    }
                }

                // alert
                baggleAlert(viewStore: viewStore)
            }
            // 임시 액션시트
            .confirmationDialog("임시 액션시트", isPresented: $isActionSheetShow, actions: {
                Button("방 폭파하기") {
                    viewStore.send(.deleteButtonTapped)
                }

                Button("방장 넘기기") {
                    viewStore.send(.leaveButtonTapped)
                }

                Button {
                    viewStore.send(.cameraButtonTapped)
                } label: {
                    Text("카메라")
                }
            })
            .sheet(
                store: self.store.scope(
                    state: \.$selectOwner,
                    action: { .selectOwner($0) })
            ) { selectOwnerStore in
                SelectOwnerView(store: selectOwnerStore)
                    .presentationDetents([.height(340)])
                    .presentationDragIndicator(.visible)
            }
            .fullScreenCover(
                store: self.store.scope(
                    state: \.$usingCamera,
                    action: { .usingCamera($0)}
                )
            ) { cameraStore in
                    CameraView(store: cameraStore)
            }
            .onAppear { viewStore.send(.onAppear) }
            .onDisappear { viewStore.send(.delegate(.onDisappear)) }
            .onChange(of: viewStore.dismiss, perform: { _ in
                dismiss()
            })
        }
    }
}

extension MeetingDetailView {
    typealias Viewstore = ViewStore<MeetingDetailFeature.State, MeetingDetailFeature.Action>

    func headerView(viewStore: Viewstore) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // 모임방 이름, 스탬프
            HStack(alignment: .top) {
                Text("📌")

                // TODO: - scaleToFit 수정
                Text("수빈님네 집들이집들이 집들이집들이집")
                    .kerning(-0.5)
                    .lineSpacing(8)
                    .lineLimit(2)
                    .frame(maxWidth: 190, alignment: .leading)

                Image(systemName: "stamp")
                    .frame(width: 56, height: 23)
                    .background(.gray)

                Spacer()
            }
            .padding(.bottom, 10)
            .font(.system(size: 22, weight: .bold))

            // 장소, 시간
            Text(attributedColorString(str: "장소  |  수빈님 없는 수빈님네 집",
                                       targetStr: "장소  |",
                                       color: .black,
                                       targetColor: .gray))
            .font(.system(size: 15))

            Text(attributedColorString(str: "시간  |  2023년 12월 30일 18:30",
                                       targetStr: "시간  |",
                                       color: .black,
                                       targetColor: .gray))
            .font(.system(size: 15))
            .padding(.bottom, 20)

            // 메모
            Text("작성된 메모가 있어요 작성된 메모가 있어요작성된 작성된 메모가 있어요작성된 메모가 있어요")
                .padding(.vertical, 14)
                .padding(.horizontal, 20)
                .background(.white)
                .cornerRadius(8)
        }
        .padding(EdgeInsets(top: 64, leading: 20, bottom: 24, trailing: 20))
        .background(.blue.opacity(0.2))
    }

    func memberListView(viewStore: Viewstore) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(viewStore.meetingData?.members ?? [], id: \.self) { member in
                    VStack(spacing: 4) {
                        // TODO: - 방장, 긴급 버튼 할당자 표시
                        CircleProfileView(
                            imageUrl: "https://avatars.githubusercontent.com/u/81167570?v=4",
                            size: .medium)

                        Text(member.name)
                            .padding(.vertical, 2)
                            .font(.system(size: 13))
                            .frame(maxWidth: 64)
                    }
                    .padding(.all, 2)
                }
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
    }

    func baggleAlert(viewStore: Viewstore) -> some View {
        BaggleAlert(
            isPresented: Binding(
                get: { viewStore.isAlertPresented },
                set: { _ in viewStore.send(.presentAlert) }),
            title: viewStore.alertTitle,
            description: viewStore.alertDescription,
            rightButtonTitle: viewStore.alertRightButtonTitle) {
                viewStore.send(.deleteMeeting)
            }
    }
}

struct MeetingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDetailView(
            store: Store(
                initialState: MeetingDetailFeature.State(
                    meetingId: 12345, meetingData: MeetingDetail(
                        // swiftlint:disable:next multiline_arguments
                        id: 100, name: "모임방1000", place: "강남역",
                        // swiftlint:disable:next multiline_arguments
                        date: "2023년 4월 9일", time: "16:40", memo: "ㅇㅇ",
                        members: [Member(
                            // swiftlint:disable:next multiline_arguments
                            id: 1, name: "콩이", profileURL: "",
                            // swiftlint:disable:next multiline_arguments
                            isOwner: true, certified: false, certImage: "")],
                        isConfirmed: false,
                        // swiftlint:disable:next multiline_arguments
                        emergencyButtonActive: false, emergencyButtonActiveTime: "")),
                reducer: MeetingDetailFeature()
            )
        )
    }
}
