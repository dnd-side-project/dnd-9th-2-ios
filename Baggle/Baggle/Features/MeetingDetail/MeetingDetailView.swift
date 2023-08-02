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

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 20) {
                    Text("모임 생성")
                        .font(.title)

                    if let data = viewStore.meetingData {
                        Text("모임명: \(data.name), 모임 id: \(data.id)")
                    }

                    HStack(spacing: 10) {
                        Button("방 폭파하기") {
                            viewStore.send(.deleteButtonTapped)
                        }

                        Button("방장 넘기기") {
                            print("방장 넘기기 alert")
                            viewStore.send(.leaveButtonTapped)
                        }
                    }

                    Button("뒤로가기") {
                        viewStore.send(.backButtonTapped)
                    }
                    .buttonStyle(BagglePrimaryStyle(size: .small, shape: .round))
                }

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
            .onAppear {
                viewStore.send(.onAppear)
            }
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
                            userid: 1, name: "콩이", profileURL: "",
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
