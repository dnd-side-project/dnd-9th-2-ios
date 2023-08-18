//
//  DescriptionView.swift
//  Baggle
//
//  Created by youtak on 2023/08/18.
//

import SwiftUI

struct DescriptionView: View {
    
    @Binding private var isPresented: Bool
    private let text: String
    
    init(isPresented: Binding<Bool>, text: String) {
        self._isPresented = isPresented
        self.text = text
    }
    
    var body: some View {
        ZStack {
            ShadeView(isPresented: $isPresented)
            
            Text(text)
                .multilineTextAlignment(.center)
                .font(.Baggle.subTitle1)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(.black)
                .cornerRadius(12)
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
        .onTapGesture {
            isPresented.toggle()
        }
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(
            isPresented: .constant(true),
            text: "시간 경과로 긴급 버튼이 자동으로 호출됐습니다."
        )
    }
}
