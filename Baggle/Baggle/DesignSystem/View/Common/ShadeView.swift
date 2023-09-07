//
//  BackgroundDimmerView.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

struct ShadeView: View {
    
    @Binding private var isPresented: Bool
    let enableTouch: Bool
    
    init(isPresented: Binding<Bool>, enableTouch: Bool = true) {
        self._isPresented = isPresented
        self.enableTouch = enableTouch
    }
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.gray10
                    .opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: self.isPresented)
        .onTapGesture {
            if enableTouch {
                isPresented.toggle()
            }
        }
    }
}
