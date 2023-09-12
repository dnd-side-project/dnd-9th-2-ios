//
//  MemberInfoView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/03.
//

import SwiftUI

struct MeetingLeaveMemberView: View {

    var meetingLeaveMember: MeetingLeaveMember
    var isSelected: Bool

    var body: some View {

        VStack(spacing: 10) {
            CircleProfileView(imageUrl: meetingLeaveMember.profileURL, size: .xLarge)
                .overlay {
                    if isSelected {
                        Circle()
                            .fill(Color.primaryNormal.opacity(0.3))
                        
                        Circle()
                            .stroke(Color.primaryNormal, lineWidth: 3)
                    }
                }
            
            Text(meetingLeaveMember.name)
                .font(.Baggle.body3)
                .foregroundColor(isSelected ? Color.primaryNormal : .gray11)
        }
    }
}

struct MeetingLeaveMemberView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingLeaveMemberView(
            meetingLeaveMember: MeetingLeaveMember(
                id: 1,
                name: "유탁",
                // swiftlint:disable:next line_length
                profileURL: "https://i.namu.wiki/i/OXmmnGpQrbZ_6dYNGRIrCQEkKqgHZhBwxBU-KmfbjLZVknsUN8iXU2jYzVWFQb4P9qbVVHKiM5SfCa1_DXGLlS58m7UthtaWsCTmHlHvyvl6FR2kGRSYhZZ6T4Nr9nAeBUKMJpMzFrF6U-jvpunjgQ.webp"),
            isSelected: true
        )
    }
}
