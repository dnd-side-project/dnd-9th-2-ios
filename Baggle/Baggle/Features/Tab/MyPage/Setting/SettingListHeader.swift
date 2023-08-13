//
//  SettingListHeader.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import SwiftUI

struct SettingListHeader: View {
    
    let text: String
    
    var body: some View {
        
        HStack {
            Text(text)
                .font(.Baggle.description)
                .foregroundColor(.gray6)
            
            Spacer()
        }
        .padding(20)
    }
}

struct SettingListHeader_Previews: PreviewProvider {
    static var previews: some View {
        SettingListHeader(text: "Header")
    }
}
