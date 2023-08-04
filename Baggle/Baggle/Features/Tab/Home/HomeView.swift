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
            VStack(spacing: 10) {
                Text("Home View")
                    .padding()

                        Button {
                            viewStore.send(.shareButtonTapped)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "paperplane")

                                Text("카카오톡 공유하기")
                            }
                        }
                        .buttonStyle(BaggleSecondaryStyle())

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
