//
//  BackgroundDimmerView.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

struct BackgroundDimmerView: View {
    @Binding private var isPresented: Bool

    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }

    var body: some View {
        Color.black
            .opacity(isPresented ? 0.2 : 0)
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity.animation(.easeInOut))
            .animation(.easeInOut(duration: 0.2), value: self.isPresented)
            .onTapGesture {
                isPresented.toggle()
            }
    }
}
