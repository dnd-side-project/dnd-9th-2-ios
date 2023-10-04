//
//  HomeView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct HomeView: View {
    
    let store: StoreOf<HomeFeature>
    
    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            ZStack(alignment: .top) {
                
                ScrollView {
                    // userInfo + segmentedPicker
                    header(viewStore: viewStore)
                    
                    if viewStore.homeStatus == .normal {
                        Section {
                            LazyVStack(spacing: 12) {
                                ForEach((viewStore.meetingStatus == .scheduled)
                                        ? viewStore.progressList : viewStore.completedList
                                ) { meeting in
                                    MeetingListCell(data: meeting)
                                        .onTapGesture {
                                            viewStore.send(.pushToMeetingDetail(meeting.id))
                                        }
                                        .onAppear {
                                            let list = (viewStore.meetingStatus == .scheduled)
                                            ? viewStore.progressList : viewStore.completedList
                                            guard let index = list.firstIndex(where: {
                                                $0.id == meeting.id
                                            }) else { return }
                                            
                                            if index % viewStore.size == viewStore.size-1 {
                                                viewStore.send(.scrollReachEnd((index)))
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 23)
                        }
                    } else {
                        HomeMeetingListEmptyView(status: viewStore.homeStatus)
                    }
                }
                .refreshable {
                    viewStore.send(.refreshMeetingList)
                }
                
                if viewStore.isRefreshing {
                    ProgressView()
                        .padding(.top, 60)
                        .tint(.white)
                }
                
                gradientTop()
            }
            .edgesIgnoringSafeArea(.top)
            .onReceive(
                NotificationCenter.default.publisher(for: .moveMeetingDetail),
                perform: { noti in
                    if let id = noti.object as? Int {
                        viewStore.send(.refreshMeetingList)
                        viewStore.send(.pushToMeetingDetail(id))
                    }
                }
            )
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

extension HomeView {
    func gradientTop() -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: UIApplication.shared.statusBarHeight)
    }

    func header(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
        GeometryReader { geo in
            let yOffset = geo.frame(in: .global).minY > 0 ? -geo.frame(in: .global).minY : 0
            
            ZStack(alignment: .bottomLeading) {
                
                Image.Background.homeShort
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height - yOffset)
                    .clipped()
                    .offset(y: yOffset)
                
                VStack(spacing: 64) {
                    // 유저 정보
                    HomeUserInfoView(user: viewStore.user)
                    
                    // segmentedPicker
                    SegmentedPickerView(
                        segment: [
                            Segment(
                                id: .scheduled,
                                count: viewStore.progressCount,
                                isSelected: viewStore.meetingStatus == .scheduled,
                                action: {
                                    viewStore.send(.changeMeetingStatus(.scheduled))
                                }),
                            Segment(
                                id: .past,
                                count: viewStore.completedCount,
                                isSelected: viewStore.meetingStatus == .past,
                                action: {
                                    viewStore.send(.changeMeetingStatus(.past))
                                })
                        ])
                }
                .offset(y: yOffset)
            }
        }
        .frame(height: 260)
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
