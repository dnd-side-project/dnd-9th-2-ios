//
//  EmergencyView.swift
//  Baggle
//
//  Created by youtak on 2023/08/07.
//

import SwiftUI

import ComposableArchitecture

struct EmergencyView: View {

    let store: StoreOf<EmergencyFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            VStack {
                
                // MARK: - Description
                
                VStack {
                    Text(attributedColorString(str: "긴급버튼을 눌러\n참여자를 호출하세요", targetStr: "긴급버튼", color: .black, targetColor: .baggleRed))
                        .font(.system(size: 24).bold())
                        .padding(.vertical, 8)
                    
                    Text("긴급버튼을 누르면 5분 내로 현재 상황을\n인증해야해요!")
                }
                .padding(.top, 8)
                .multilineTextAlignment(.center)
                
                Spacer()
                
                // MARK: - Button
                
                VStack(spacing: 30) {
                    BubbleView(type: .secondary, text: "긴급 버튼을 눌러보세요!")
                    
                    Image(systemName: "light.beacon.max")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220)
                }
                .padding(.bottom, 120)
                
                
            }
        }
    }
}

struct EmergencyView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyView(
            store: Store(
                initialState: EmergencyFeature.State(),
                reducer: EmergencyFeature()
            )
        )
    }
}
