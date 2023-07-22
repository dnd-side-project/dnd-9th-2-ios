//
//  SsangButtonStyle.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

struct SsangButtonStyle: ButtonStyle {
    private var type: ButtonType
    @Binding var state: ButtonState
    
    init(type: ButtonType = ButtonType(size: .large, shape: .square),
         state: Binding<ButtonState>) {
        self.type = type
        self._state = state
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.width*type.size.ratio, height: 62)
            .foregroundColor(configuration.isPressed ? state.fgColor.opacity(0.5) : state.fgColor)
            .background(configuration.isPressed ? state.bgColor.opacity(0.5) : state.bgColor)
            .cornerRadius(type.shape.radius)
            .shadow(color: Color(.systemGray4).opacity(0.6), radius: 4)
    }
}
