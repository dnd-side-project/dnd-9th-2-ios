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
                ScrollView {
                    // section 간의 간격을 없애기 위해 사용
                    VStack(spacing: 0) {
                        userHeader()

                        // sticky header
                        LazyVStack(pinnedViews: [.sectionHeaders]) {
                            Section(header: listHeader(viewStore: viewStore)) {
                                VStack(spacing: 12) {
                                    ForEach((viewStore.meetingStatus == .ongoing)
                                            ? viewStore.ongoingList : viewStore.completedList
                                    ) { meeting in
                                        // cell
                                        MeetingListCell(data: meeting)
                                            .onTapGesture {
                                                viewStore.send(.pushToMeetingDetail(meeting.id))
                                            }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 23)
                            }
                        }
                    }
                }
                .clipped()

                // 임시 버튼
                tempButton(viewStore: viewStore)
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

extension HomeView {
    func userHeader() -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("2조최강킹짱왕님의 \nBaggle!")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineSpacing(1.08)

                Spacer()

                Circle()
                    .fill(.gray)
                    .frame(width: 72, height: 72)
            }
            .padding(.top, 36)
            .padding(.horizontal, 20)

            Spacer()
        }
        .frame(height: 216)
        .background(.blue)
    }

    func listHeader(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
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
        .background(.gray)
    }

    // 임시 버튼
    func tempButton(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
        VStack {
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
            }
            .padding()
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
