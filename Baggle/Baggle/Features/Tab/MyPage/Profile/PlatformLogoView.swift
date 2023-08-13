//
//  PlatformLogoView.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import SwiftUI

struct PlatformLogoView: View {
    
    let platform: LoginPlatform
    
    var body: some View {
        switch self .platform {
        case .apple:
            Image(systemName: "apple.logo")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .padding(4)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(30)
        case .kakao:
            Image.Icon.kakao
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .padding(4)
                .background(.yellow)
                .cornerRadius(30)
        }
    }
}

struct PlatformLogoView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformLogoView(platform: .apple)
    }
}
