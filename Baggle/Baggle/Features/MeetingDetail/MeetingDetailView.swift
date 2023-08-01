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
            VStack(spacing: 20) {
                Text("모임 생성")
                    .font(.title)

                if let data = viewStore.meetingData {
                    Text("모임명: \(data.name), 모임 id: \(data.id)")
                }

                Button("삭제하기") {
                    viewStore.send(.deleteMeeting)
                }
                .buttonStyle(BagglePrimaryStyle(size: .small, shape: .round))

                Button("뒤로가기") {
                    dismiss()
                }
                .buttonStyle(BagglePrimaryStyle(size: .small, shape: .round))
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onChange(of: viewStore.isDeleted) { _ in
                dismiss()
                // onReceive가 onAppear보다 먼저 실행되기 때문에
                // 딜레이 주지 않는 경우 refresh와 onappear(fetch) 둘다 실행됨
                // onReceive - refreshMeetingList 한번만 실행되도록
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
//                    postObserverAction(.refreshMeetingList)
//                }
            }
        }
    }
}

struct MeetingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDetailView(
            store: Store(
                initialState: MeetingDetailFeature.State(),
                reducer: MeetingDetailFeature(meetingId: 1)
            )
        )
    }
}
