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

                VStack { // 임시 버튼용 Vstack

                    ScrollView {
                        // userInfo + segmentedPicker
                        header(viewStore: viewStore)

                        if viewStore.homeStatus == .normal {
                            Section {
                                VStack(spacing: 12) {
                                    ForEach((viewStore.meetingStatus == .progress)
                                            ? viewStore.progressList : viewStore.completedList
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
                        } else {
                            emptyView(viewStore.homeStatus)
                        }
                    }
                    .refreshable {
                        viewStore.send(.refreshMeetingList)
                    }

                    // 임시 버튼
                    tempButton(viewStore: viewStore)
                }

                if viewStore.isRefreshing {
                    ProgressView()
                        .padding(.top, 60)
                        .tint(.white)
                }

                gradientTop()
            }
            .edgesIgnoringSafeArea(.top)
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
            .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
    }

    func emptyView(_ status: HomeStatus) -> some View {
        VStack(spacing: 12) {
            Image.Background.empty
                .padding(.top, screenSize.height*0.2)

            VStack(spacing: 4) {
                Text(status.title ?? "")
                    .foregroundColor(.gray6)

                Text(status.description ?? "")
                    .foregroundColor(.gray5)
            }
        }
    }

    func userInfo(user: User) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(user.name)님의")
                    .font(.Baggle.title)
                    .foregroundColor(.white)
                
                Image.BaggleText.mainHome
            }

            Spacer()

            KFImage(URL(string: user.profileImageURL))
                .placeholder({ _ in
                    Color.gray2
                })
                .resizable()
                .aspectRatio(1.0, contentMode: .fill)
                .cornerRadius(36)
                .clipped()
                .frame(width: 72, height: 72)
        }
        .frame(height: 72)
        .padding(.horizontal, 20)
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
                    userInfo(user: viewStore.user)

                    // segmentedPicker
                    SegmentedPickerView(
                        segment: [
                            Segment(
                                id: .progress,
                                count: viewStore.progressList.count,
                                isSelected: viewStore.meetingStatus == .progress,
                                action: {
                                    viewStore.send(.changeMeetingStatus(.progress))
                                }),
                            Segment(
                                id: .completed,
                                count: viewStore.completedList.count,
                                isSelected: viewStore.meetingStatus == .completed,
                                action: {
                                    viewStore.send(.changeMeetingStatus(.completed))
                                })
                        ])
                }
                .offset(y: yOffset)
            }
        }
        .frame(height: 260)
    }

    // 임시 버튼
    func tempButton(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
        HStack(spacing: 20) {
            Button {
                viewStore.send(.fetchMeetingList(.progress))
            } label: {
                Text("예정된 약속 업데이트")
            }

            Button {
                viewStore.send(.fetchMeetingList(.completed))
            } label: {
                Text("지난 약속 업데이트")
            }

            Button {
                viewStore.send(.cameraButtonTapped)
            } label: {
                Text("카메라")
            }
        }
        .padding()
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
