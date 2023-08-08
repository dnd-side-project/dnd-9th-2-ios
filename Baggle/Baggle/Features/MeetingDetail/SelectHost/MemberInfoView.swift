//
//  MemberInfoView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/03.
//

import SwiftUI

struct MemberInfoView: View {
    var memberInfo: Member
    var selected: Bool

    var body: some View {

        VStack(spacing: 10) {
            Text("\(memberInfo.id)")

            Text(memberInfo.name)
        }
        .foregroundColor(.gray43)
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(selected ? .blue : .gray)
            .background(selected ? .blue.opacity(0.2) : .clear))
        .cornerRadius(8)
    }
}

struct MemberInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MemberInfoView(memberInfo:
                        Member(
                            // swiftlint:disable:next multiline_arguments
                            id: 100, name: "유저1", profileURL: "",
                            // swiftlint:disable:next multiline_arguments line_length
                            isMeetingAuthority: false, isButtonAuthority: true, certified: false, certImage: ""),
                       selected: false
        )
    }
}
