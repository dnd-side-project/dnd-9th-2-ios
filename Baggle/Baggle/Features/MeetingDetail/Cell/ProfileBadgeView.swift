//
//  ProfileBadgeView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/07.
//

import SwiftUI

enum OwnerTag {
    case meeting
    case button
}

struct ProfileBadgeView: View {
    let tag: OwnerTag

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray14)
                .frame(width: 24, height: 24)

            switch tag {
            case .button:
                Image.Icon.siren
                    .resizable()
                    .frame(width: 15, height: 15)
            case .meeting:
                Image.Icon.crown
                    .resizable()
                    .frame(width: 15, height: 15)
            }
        }
    }
}

struct ProfileBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBadgeView(tag: .button)
    }
}
