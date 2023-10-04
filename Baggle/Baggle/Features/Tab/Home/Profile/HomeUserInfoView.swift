//
//  HomeUserInfoView.swift
//  Baggle
//
//  Created by youtak on 2023/10/04.
//

import SwiftUI

struct HomeUserInfoView: View {
    
    let user: User
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(user.name)님의")
                    .font(.Baggle.title)
                    .foregroundColor(.white)
                
                Image.BaggleText.mainHome
                    .padding(.leading, 2)
            }
            
            Spacer()
            
            CircleProfileView(imageUrl: user.profileImageURL, size: .large)
        }
        .frame(height: 72)
        .padding(.horizontal, 20)
    }
}

struct HomeUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        HomeUserInfoView(
            user: User(
                id: 0,
                name: "테스트유저",
                profileImageURL: "",
                platform: .kakao
            )
        )
    }
}
