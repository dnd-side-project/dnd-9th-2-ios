//
//  LoadingView.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
        .background(.gray.opacity(0.2))
        .zIndex(10)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
