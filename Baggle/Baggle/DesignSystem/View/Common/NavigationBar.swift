//
//  NaviBarView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/07.
//

import SwiftUI

enum NaviType {
    case dismiss
    case more

    var rightButton: Image {
        switch self {
        case .dismiss: return Image.Icon.close
        case .more: return Image.Icon.more
        }
    }
}

struct NavigationBar: View {

    let naviType: NaviType
    let backButtonAction: () -> Void
    let rightButtonAction: () -> Void

    var body: some View {
        HStack {
            Button {
                backButtonAction()
            } label: {
                Image.Icon.backTail
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Button {
                rightButtonAction()
            } label: {
                naviType.rightButton
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 56)
    }
}

struct NaviBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(
            naviType: .more,
            backButtonAction: {
                print("뒤로가자")
            }, rightButtonAction: {
                print("오른쪽 버튼")
            })
            .previewLayout(.sizeThatFits)
    }
}
