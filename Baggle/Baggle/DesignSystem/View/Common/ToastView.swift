//
//  ToastView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/19.
//

import SwiftUI

struct ToastView: View {
    
    private var text: String
    
    @State var isAnimated: Bool = false
    
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(text)
                .fontWithLineSpacing(fontType: .body2)
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 26)
                .background(Color.gray11.opacity(0.9))
                .cornerRadius(12)
            
            Spacer()
        }
        .opacity(isAnimated ? 1 : 0)
        .transition(.asymmetric(
            insertion: .opacity.animation(.easeInOut(duration: 0.2)),
            removal: .opacity.animation(.easeInOut(duration: 0.2).delay(0.8))
        ))
        .onAppear {
            withAnimation {
                isAnimated = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.6) {
                withAnimation {
                    isAnimated = false
                }
            }
        }
        .zIndex(100)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView("신고가 정상적으로 접수되었습니다.")
    }
}
