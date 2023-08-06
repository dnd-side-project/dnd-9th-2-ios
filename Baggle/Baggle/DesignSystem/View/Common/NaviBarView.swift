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

    var rightButton: String {
        switch self {
        case .dismiss: return "xmark"
        case .more: return "ellipsis"
        }
    }
}

struct NaviBarView: View {

    let naviType: NaviType
    let backButtonAction: () -> Void
    let rightButtonAction: () -> Void

    var body: some View {
        HStack {
            Button {
                backButtonAction()
            } label: {
                Image(systemName: "arrow.backward")
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Button {
                rightButtonAction()
            } label: {
                Image(systemName: naviType.rightButton)
                    .frame(width: 44, height: 44)
            }
        }
        .foregroundColor(.black)
        .padding(.horizontal, 10)
        .frame(height: 56)
    }
}

struct NaviBarView_Previews: PreviewProvider {
    static var previews: some View {
        NaviBarView(
            naviType: .more,
            backButtonAction: {
                print("뒤로가자")
            }, rightButtonAction: {
                print("오른쪽 버튼")
            })
            .previewLayout(.sizeThatFits)
    }
}
