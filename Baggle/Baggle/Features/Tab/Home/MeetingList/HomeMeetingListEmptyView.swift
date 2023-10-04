//
//  HomeMeetingListEmptyView.swift
//  Baggle
//
//  Created by youtak on 2023/10/04.
//

import SwiftUI

struct HomeMeetingListEmptyView: View {
    
    let status: HomeStatus
    
    var body: some View {
        VStack(spacing: 12) {
            status.image
                .padding(.top, screenSize.height * status.ratio)
            
            VStack(spacing: 4) {
                Text(status.title ?? "")
                    .foregroundColor(.gray6)
                
                Text(status.description ?? "")
                    .foregroundColor(.gray5)
            }
        }
    }
}

struct HomeMeetingListEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMeetingListEmptyView(status: .empty)
    }
}
