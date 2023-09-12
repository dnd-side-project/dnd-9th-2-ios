//
//  HostPickerView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/03.
//

import SwiftUI

import ComposableArchitecture

struct SelectOwnerView: View {

    private let secondLowCount: Int = 2
    
    let store: StoreOf<SelectOwnerFeature>
    let meetingLeaveMember: [MeetingLeaveMember]
    
    var memberCount: Int {
        return meetingLeaveMember.count
    }

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                
                HStack {
                    Spacer()

                    Button {
                        viewStore.send(.cancelButtonTapped)
                    } label: {
                        Image.Icon.close
                    }
                }
                
                VStack(spacing: 10) {
                    Text("방장을 넘기고 나가시겠어요?")
                        .font(.baggleFont(fontType: .subTitle1))
                        .foregroundColor(.gray8)
                    
                    Text("방장을 넘길 친구를 선택해주세요")
                        .font(.baggleFont(fontType: .body2))
                        .foregroundColor(.gray8)
                }
                    

                Spacer()

                HStack(spacing: 16) {
                    ForEach(
                        meetingLeaveMember.prefix(firstLowCount()),
                        id: \.id
                    ) { member in
                        MeetingLeaveMemberView(
                            meetingLeaveMember: member,
                            isSelected: viewStore.selectedMemberID == member.id
                        )
                        .onTapGesture {
                            viewStore.send(.selectMember(member.id))
                        }
                    }
                }
                
                if isTwoLines() {
                    HStack(spacing: 16) {
                        ForEach(
                            meetingLeaveMember.suffix(secondLowCount),
                            id: \.id
                        ) { member in
                            MeetingLeaveMemberView(
                                meetingLeaveMember: member,
                                isSelected: viewStore.selectedMemberID == member.id
                            )
                            .onTapGesture {
                                viewStore.send(.selectMember(member.id))
                            }
                        }
                    }
                    .padding(.top, 10)
                }

                Spacer()

                Button("방장 넘기고 나가기") {
                    viewStore.send(.leaveButtonTapped)
                }
                .buttonStyle(BagglePrimaryStyle())
                .disabled(viewStore.leaveButtonDisabled)
            }
        }
        .padding()
    }
}

extension SelectOwnerView {

    private func isTwoLines() -> Bool {
        return memberCount > 3
    }
    
    private func firstLowCount() -> Int {
        return memberCount > 3 ? memberCount - secondLowCount : memberCount
    }
}

struct SelectOwnerView_Previews: PreviewProvider {
    static var previews: some View {
        SelectOwnerView(
            store: Store(
                initialState: SelectOwnerFeature.State(),
                reducer: SelectOwnerFeature()
            ),
            meetingLeaveMember: [
                MeetingLeaveMember(id: 1, name: "수빈", profileURL: "https://i.namu.wiki/i/OXmmnGpQrbZ_6dYNGRIrCQEkKqgHZhBwxBU-KmfbjLZVknsUN8iXU2jYzVWFQb4P9qbVVHKiM5SfCa1_DXGLlS58m7UthtaWsCTmHlHvyvl6FR2kGRSYhZZ6T4Nr9nAeBUKMJpMzFrF6U-jvpunjgQ.webp"),
                MeetingLeaveMember(id: 2, name: "유탁", profileURL: "https://i.namu.wiki/i/KSlJDAdoBtpnTzmwMv8dt4fXffy8CzUt4mTrzEptnyuc3ZGD9V-Qh8GNX_C7D6NSiwxl5n6aKTVsl6ymcJH2Mr9HJ-N4BfF6-HxeEuileIky3J_MCBoqghRZSYjt1Zuh7pMlCqv28Em85p8q0RzBtA.webp"),
//                MeetingLeaveMember(id: 3, name: "채이", profileURL: "")
            ]
        )
        .background(Color.blue.opacity(0.1))
        .frame(height: 340)
        
        SelectOwnerView(
            store: Store(
                initialState: SelectOwnerFeature.State(),
                reducer: SelectOwnerFeature()
            ),
            meetingLeaveMember: [
                MeetingLeaveMember(id: 1, name: "수빈", profileURL: "https://i.namu.wiki/i/OXmmnGpQrbZ_6dYNGRIrCQEkKqgHZhBwxBU-KmfbjLZVknsUN8iXU2jYzVWFQb4P9qbVVHKiM5SfCa1_DXGLlS58m7UthtaWsCTmHlHvyvl6FR2kGRSYhZZ6T4Nr9nAeBUKMJpMzFrF6U-jvpunjgQ.webp"),
                MeetingLeaveMember(id: 2, name: "유탁", profileURL: "https://i.namu.wiki/i/KSlJDAdoBtpnTzmwMv8dt4fXffy8CzUt4mTrzEptnyuc3ZGD9V-Qh8GNX_C7D6NSiwxl5n6aKTVsl6ymcJH2Mr9HJ-N4BfF6-HxeEuileIky3J_MCBoqghRZSYjt1Zuh7pMlCqv28Em85p8q0RzBtA.webp"),
                MeetingLeaveMember(id: 3, name: "채이", profileURL: ""),
                MeetingLeaveMember(id: 4, name: "선웅", profileURL: ""),
                MeetingLeaveMember(id: 5, name: "관곤", profileURL: ""),
            ]
        )
        .background(Color.blue.opacity(0.1))
        .frame(height: 460)
    }
}
