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
        NavigationStackStore(self.store.scope(
            state: \.path,
            action: { .path($0) })) {
                WithViewStore(self.store, observe: { $0 }) { viewStore in
                    VStack(spacing: 10) {
                        Text("Home View")
                            .padding()

                        Button {
                            viewStore.send(.shareButtonTapped)
                        } label: {
                            Text("카카오톡 공유하기")
                        }
                        .buttonStyle(BagglePrimaryStyle())

                        HStack(spacing: 20) {
                            Button {
                                viewStore.send(.changeMeetingStatus(.ongoing))
                            } label: {
                                Text("진행중인 모임")
                            }

                            Button {
                                viewStore.send(.changeMeetingStatus(.complete))
                            } label: {
                                Text("지난 모임")
                            }

                            Button {
                                viewStore.send(.refreshMeetingList)
                            } label: {
                                Text("모임 리프레시")
                            }
                        }
                        .padding()

                        List((viewStore.meetingStatus == .ongoing)
                             ? viewStore.ongoingList : viewStore.completedList) { meeting in
                            NavigationLink(state: MeetingDetailFeature.State(
                                meetingId: meeting.id)
                            ) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("\(meeting.id)")
                                        .font(.caption)
                                    Text(meeting.name)
                                }
                            }
                        }

                        HStack(spacing: 20) {
                            Button {
                                viewStore.send(.fetchMeetingList(.ongoing))
                            } label: {
                                Text("진행중인 모임 업데이트")
                            }

                            Button {
                                viewStore.send(.fetchMeetingList(.complete))
                            } label: {
                                Text("지난 모임 업데이트")
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
                            viewStore.send(.moveToMeetingDetail(id))
                        }
                    })
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                    // 푸시알림 탭해서 들어오는 경우
                    .navigationDestination(
                        isPresented: Binding(
                            get: { viewStore.pushMeetingDetailId != nil },
                            set: { _ in
                                viewStore.send(.moveToMeetingDetail(
                                    viewStore.pushMeetingDetailId ?? 0))
                            })
                    ) {
                        MeetingDetailView(
                            store: Store(
                                initialState: MeetingDetailFeature.State(
                                    meetingId: viewStore.pushMeetingDetailId ?? 0),
                                reducer: MeetingDetailFeature()
                            )
                        )
                    }
                }
            } destination: { store in
                MeetingDetailView(store: store)
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
