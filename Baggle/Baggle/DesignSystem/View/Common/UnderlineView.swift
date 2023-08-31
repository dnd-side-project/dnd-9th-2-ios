//
//  UnderlineView.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

struct UnderlineView: ViewModifier {
    let spacing: CGFloat
    let height: CGFloat
    let color: Color
    let padding: CGFloat
    
    func body(content: Content) -> some View {
        VStack(spacing: spacing) {
            content
            Rectangle()
                .frame(height: height)
                .padding(.horizontal, padding)
                .foregroundColor(color)
        }
    }
}
