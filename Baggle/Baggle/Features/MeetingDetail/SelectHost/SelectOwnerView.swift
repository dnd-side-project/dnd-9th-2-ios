//
//  HostPickerView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/03.
//

import SwiftUI

import ComposableArchitecture

struct SelectOwnerView: View {

    let store: StoreOf<SelectOwnerFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Text("방장을 넘길 친구를 선택해주세요")
                    .padding(.top, 30)

                Spacer()

                HStack {
                    ForEach(viewStore.memberList, id: \.id) { member in
                        MemberInfoView(memberInfo: member,
                                       selected: viewStore.selectedMemberId == member.id)
                        .onTapGesture {
                            viewStore.send(.selectMember(member.id))
                        }
                    }
                }

                Spacer()

                Button("방장 넘기고 나가기") {
                    viewStore.send(.leaveButtonTapped)
                }
                .buttonStyle(BagglePrimaryStyle())
                .disabled(viewStore.leaveButtonDisabled)
            }
        }
    }
}

struct HostPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SelectOwnerView(
            store: Store(
                initialState: SelectOwnerFeature.State(
                    memberList: [
                        // swiftlint:disable:next multiline_arguments
                        Member(id: 100, name: "유저1", profileURL: "",
                               // swiftlint:disable:next multiline_arguments
                               isOwner: false, isButtonOwner: false, certified: false, certImage: ""),
                        // swiftlint:disable:next multiline_arguments
                        Member(id: 200, name: "유저2", profileURL: "",
                               // swiftlint:disable:next multiline_arguments
                               isOwner: false, isButtonOwner: false, certified: false, certImage: ""),
                        // swiftlint:disable:next multiline_arguments
                        Member(id: 300, name: "유저3", profileURL: "",
                               // swiftlint:disable:next multiline_arguments
                               isOwner: false, isButtonOwner: false, certified: false, certImage: "")
                    ]
                ),
                reducer: SelectOwnerFeature()
            )
        )
    }
}
