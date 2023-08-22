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
            // zstack 순서: alert > navigationBar > scrollView > background
            ZStack(alignment: .top) {
                
                if viewStore.isLoading {
                    LoadingView()
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        if let data = viewStore.meetingData {
                            // header
                            headerView(data: data)
                            
                            // 참여자 목록
                            memberListView(viewStore: viewStore)
                                .padding(.horizontal, 20)
                                .drawUnderline(
                                    spacing: 0,
                                    height: 0.5,
                                    color: .gray4
                                )
                                .background(.white)
                            
                            // 인증 피드
                            if !data.feeds.isEmpty {
                                feedView(
                                    feeds: data.feeds,
                                    viewStroe: viewStore
                                )
                                .padding(
                                    EdgeInsets(top: 14,
                                               leading: 20,
                                               bottom: 20,
                                               trailing: 20)
                                )
                                .background(.white)
                            } else {
                                // 엠티뷰
                                emptyView()
                                    .background(.white)
                            }
                        }
                    }
                }
                .refreshable {
                    viewStore.send(.onAppear)
                }
                
                VStack {
                    // navibar
                    NavigationBar(naviType: .more) {
                        viewStore.send(.backButtonTapped)
                    } rightButtonAction: {
                        isActionSheetShow = true
                    }
                    .background(Color.PrimaryLight)
                    
                    Spacer()
                    
                    if !(viewStore.buttonState == .none) {
                        buttonView(viewStore: viewStore)
                            .padding(.bottom, 16)
                    }
                }
                .animation(.easeOut(duration: 0.3), value: viewStore.buttonState)
                .transition(.move(edge: .bottom))
                
                // Error - alert
                
                if let alertType = viewStore.alertType {
                    if alertType.buttonType == .one {
                        BaggleAlertOneButton(
                            isPresented: Binding(
                                get: { viewStore.alertType != nil },
                                set: { viewStore.send(.presentAlert($0)) }
                            ),
                            title: alertType.title,
                            description: alertType.description,
                            buttonTitle: alertType.buttonTitle
                        ) {
                            viewStore.send(.alertButtonTapped)
                        }
                    } else if alertType.buttonType == .two {
                        BaggleAlertTwoButton(
                            isPresented: Binding(
                                get: { viewStore.alertType != nil },
                                set: { viewStore.send(.presentAlert($0)) }
                            ),
                            title: alertType.title,
                            description: alertType.description,
                            alertType: .destructive,
                            rightButtonTitle: alertType.buttonTitle,
                            leftButtonAction: nil
                        ) {
                            viewStore.send(.alertButtonTapped)
                        }
                    }
                }
                
                // 이미지 상세
                if viewStore.isImageTapped,
                   let image = viewStore.tappedImageUrl {
                    imageDetailView(image: image, viewStore: viewStore)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            // 임시 액션시트
            .confirmationDialog("임시 액션시트", isPresented: $isActionSheetShow, actions: {
                Button("방 폭파하기") { viewStore.send(.deleteButtonTapped) }
                
                Button("방장 넘기기") { viewStore.send(.leaveButtonTapped) }
                
                Button("카메라") { viewStore.send(.cameraButtonTapped) }
                
                Button("긴급 버튼") { viewStore.send(.emergencyButtonTapped) }
                
                Button("초대장 보내기") { viewStore.send(.inviteButtonTapped) }
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
            .fullScreenCover(
                store: self.store.scope(
                    state: \.$emergencyState,
                    action: { .emergencyAction($0) }
                )
            ) { emergencyStore in
                EmergencyView(store: emergencyStore)
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
    // swiftlint:disable:next line_length
    typealias MeetingDetailViewStore = ViewStore<MeetingDetailFeature.State, MeetingDetailFeature.Action>
    
    func meetingTitleView(name: String, status: MeetingStampStatus) -> some View {
        HStack(alignment: .top) {
            Text("📌")
            
            Text("\(name)")
                .fontWithLineSpacing(fontType: .subTitle1)
                .frame(maxWidth: name.width > 200 ? 200 : .none, alignment: .leading)
                .padding(.trailing, 4)
                .foregroundColor(.gray9)
            
            Group {
                if status == .termination {
                    Image.Stamp.complete
                        .resizable()
                } else if status == .confirmation {
                    Image.Stamp.confirm
                        .resizable()
                }
            }
            .frame(width: 56, height: 23)
            .padding(.top, name.width > 200 ? 2.5 : 0) // 두 줄인 경우 상단 패딩 추가
            
            Spacer()
        }
        .padding(.bottom, 10)
    }
    
    func meetingDateView(place: String, date: String, time: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(
                attributedColorString(
                    str: "장소  |  \(place)",
                    targetStr: "장소  |",
                    color: .gray9,
                    targetColor: .gray6)
            )
            
            Text(
                attributedColorString(
                    str: "시간  |  \(date) \(time)",
                    targetStr: "시간  |",
                    color: .gray9,
                    targetColor: .gray6)
            )
        }
        .fontWithLineSpacing(fontType: .body3)
    }
    
    func meetingMemoView(memo: String?) -> some View {
        Group {
            if let memo {
                Text(memo)
                    .foregroundColor(.gray7)
            } else {
                Text("작성된 메모가 없어요!")
                    .foregroundColor(.gray5)
            }
        }
        .fontWithLineSpacing(fontType: .body3)
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width-40, alignment: .leading)
        .background(.white)
        .cornerRadius(8)
    }
    
    func headerView(data: MeetingDetail) -> some View {
        GeometryReader { geo in
            let yOffset = geo.frame(in: .global).minY > 0 ? -geo.frame(in: .global).minY : 0
            
            ZStack(alignment: .bottomLeading) {
                Color.PrimaryLight
                    .frame(width: geo.size.width, height: geo.size.height - yOffset)
                    .offset(y: yOffset)
                
                VStack(alignment: .leading, spacing: 10) {
                    // 모임방 이름, 스탬프
                    meetingTitleView(
                        name: data.name,
                        status: data.stampStatus
                    )
                    
                    // 장소, 시간
                    meetingDateView(
                        place: data.place,
                        date: data.date,
                        time: data.time
                    )
                    
                    // 메모
                    meetingMemoView(memo: data.memo)
                        .padding(.top, 10)
                }
                .padding(EdgeInsets(top: 8, leading: 20, bottom: 24, trailing: 20))
                .offset(y: yOffset)
            }
        }
        .frame(
            height: (data.memo?.width(15) ?? 0) >= screenSize.width - 40 ? 240 : 188
        )
        .padding(.top, 56)
    }
    
    func memberListView(viewStore: MeetingDetailViewStore) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(viewStore.meetingData?.members ?? [], id: \.self) { member in
                    VStack(spacing: 4) {
                        ZStack(alignment: .bottomTrailing) {
                            CircleProfileView(
                                imageUrl: member.profileURL,
                                size: .medium,
                                hasStroke: member.certified
                            )
                            .onTapGesture {
                                if member.certified {
                                    viewStore.send(.imageTapped(member.certImage))
                                }
                            }
                            
                            HStack(spacing: -10) {
                                if member.isMeetingAuthority {
                                    ProfileBadgeView(tag: .meeting)
                                }
                                
                                if member.isButtonAuthority {
                                    ProfileBadgeView(tag: .button)
                                }
                            }
                        }
                        
                        Text(member.name)
                            .padding(.vertical, 2)
                            .fontWithLineSpacing(fontType: .caption2)
                            .frame(maxWidth: 64)
                    }
                    .padding(.all, 2)
                }
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    func feedView(feeds: [Feed], viewStroe: MeetingDetailViewStore) -> some View {
        VStack(spacing: 16) {
            ForEach(feeds, id: \.id) { feed in
                FeedListCell(feed: feed) {
                    print("더보기 버튼 탭")
                }
            }
        }
    }
    
    func buttonView(viewStore: MeetingDetailViewStore) -> some View {
        VStack(spacing: 4) {
            if viewStore.buttonState == .invite {
                BubbleView(
                    size: .small,
                    color: .primary,
                    text: "최대 6명"
                )
            }
            
            Button {
                viewStore.send(.eventButtonTapped)
            } label: {
                HStack(spacing: 8) {
                    viewStore.buttonState.buttonIcon
                    
                    Text(viewStore.buttonState.buttonTitle)
                    
                    if viewStore.buttonState == .authorize {
                        SmallTimerView(
                            store: self.store.scope(
                                state: \.timerState,
                                action: MeetingDetailFeature.Action.timerAction
                            )
                        )
                    }
                }
            }
            .buttonStyle(BaggleSecondaryStyle(buttonType: viewStore.buttonState))
        }
    }
    
    func imageDetailView(image: String, viewStore: MeetingDetailViewStore) -> some View {
        ImageDetailView(
            isPresented: Binding(
                get: { viewStore.isImageTapped },
                set: { _ in viewStore.send(.imageTapped(viewStore.tappedImageUrl)) }),
            imageURL: image
        ) {
            viewStore.send(.imageTapped(nil))
        }
    }
    
    func emptyView() -> some View {
        VStack(spacing: 12) {
            Image.Background.empty
                .padding(.top, screenSize.height*0.1)
            
            Text("아직 올라온 사진이 없어요!")
                .font(.Baggle.body2)
                .foregroundColor(.gray6)
        }
        .frame(width: screenSize.width)
    }
}

struct MeetingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDetailView(
            store: Store(
                initialState: MeetingDetailFeature.State(
                    meetingId: 12345
                ),
                reducer: MeetingDetailFeature()
            )
        )
    }
}
