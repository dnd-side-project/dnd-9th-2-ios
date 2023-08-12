//
//  SettingListRow.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import SwiftUI

struct SettingListRow: View {
    
    let text: String
    let isArrow: Bool
    let action: () -> Void
    
    init(text: String, isArrow: Bool = true, action: @escaping () -> Void) {
        self.text = text
        self.isArrow = isArrow
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(text)
                    .foregroundColor(.gray11)
                    .font(.Baggle.button)
                
                Spacer()
                
                if isArrow {
                    Image.Icon.next
                        .padding(10)
                }
            }
            .padding(.vertical, 10)
            .padding(.leading, 20)
            .padding(.trailing, 10)
        }
    }
}

struct SettingListRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingListRow(text: "알림 설정", isArrow: true) {
            print("hello")
        }
    }
}
