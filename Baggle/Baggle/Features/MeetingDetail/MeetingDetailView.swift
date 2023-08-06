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

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 20) {
                    Text("모임 생성")
                        .font(.title)

                    Text("id: \(viewStore.meetingId)")

                    if let data = viewStore.meetingData {
                        Text("모임명: \(data.name), 모임 id: \(data.id)")
                    }

                    HStack(spacing: 10) {
                        Button("방 폭파하기") {
                            viewStore.send(.deleteButtonTapped)
                        }

                        Button("방장 넘기기") {
                            viewStore.send(.leaveButtonTapped)
                        }
                    }

                    Button {
                        viewStore.send(.cameraButtonTapped)
                    } label: {
                        Text("카메라")
                    }
                    .buttonStyle(BagglePrimaryStyle(size: .small))

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
