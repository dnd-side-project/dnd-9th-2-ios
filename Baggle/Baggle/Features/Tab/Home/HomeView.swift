//
//  HomeView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {

    let store: StoreOf<HomeFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    HStack {
                        Text("2조최강킹짱왕님의 \nBaggle!")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineSpacing(1.3)

                        Spacer()

                        Circle()
                            .fill(.blue)
                            .frame(width: 72, height: 72)
                    }
                    .padding(.top, 36)
                    .padding(.horizontal, 20)

                    Spacer()

                    SegmentedPickerView(
                        segment: [
                            Segment(
                                id: .ongoing,
                                count: viewStore.ongoingList.count,
                                isSelected: viewStore.meetingStatus == .ongoing,
                                action: {
                                    viewStore.send(.changeMeetingStatus(.ongoing))
                                }),
                            Segment(
                                id: .complete,
                                count: viewStore.completedList.count,
                                isSelected: viewStore.meetingStatus == .complete,
                                action: {
                                    viewStore.send(.changeMeetingStatus(.complete))
                                })
                        ])
                }
                .frame(height: 260)
                .background(.blue.opacity(0.4))

                List((viewStore.meetingStatus == .ongoing)
                     ? viewStore.ongoingList : viewStore.completedList) { meeting in
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(meeting.id)")
                                .font(.caption)
                            Text(meeting.name)
                        }

                        Spacer()
                    }
                    .onTapGesture {
                        viewStore.send(.pushToMeetingDetail(meeting.id))
                    }
                }

                // 임시 버튼

                HStack(spacing: 20) {
                    Button {
                        viewStore.send(.fetchMeetingList(.ongoing))
                    } label: {
                        Text("예정된 약속 업데이트")
                    }

                    Button {
                        viewStore.send(.fetchMeetingList(.complete))
                    } label: {
                        Text("지난 약속 업데이트")
                    }
                }
                .padding()

                HStack(spacing: 20) {
                    Button {
                        viewStore.send(.refreshMeetingList)
                    } label: {
                        Text("리프레시")
                    }

                    Button {
                        viewStore.send(.shareButtonTapped)
                    } label: {
                        Text("카카오톡 공유")
                    }

                    Button {
                        viewStore.send(.cameraButtonTapped)
                    } label: {
                        Text("카메라")
                    }
                }
                .padding()
            }
            .onReceive(NotificationCenter.default.publisher(for: .refreshMeetingList),
                       perform: { _ in
                viewStore.send(.refreshMeetingList)
            })
            .onReceive(NotificationCenter.default.publisher(for: .moveMeetingDetail),
                       perform: { noti in
                // noti로부터 id 값 받아서 넣기
                if let id = noti.object as? Int {
                    viewStore.send(.pushToMeetingDetail(id))
                }
            })
            .onAppear {
                viewStore.send(.onAppear)
            }
            .navigationDestination(
                isPresented: Binding(
                    get: { viewStore.pushMeetingDetail },
                    set: { _ in viewStore.send(.pushMeetingDetail) })
            ) {
                MeetingDetailView(
                    store: self.store.scope(
                        state: \.meetingDetailState,
                        action: HomeFeature.Action.meetingDetailAction))
            }
            .fullScreenCover(
                store: self.store.scope(
                    state: \.$usingCamera,
                    action: { .usingCamera($0)}
                )
            ) { cameraStore in
                    CameraView(store: cameraStore)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            store: Store(
                initialState: HomeFeature.State(),
                reducer: HomeFeature()._printChanges()
            )
        )
    }
}
