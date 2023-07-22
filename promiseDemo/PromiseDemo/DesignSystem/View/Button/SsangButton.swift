//
//  SsangButton.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

struct SsangButton<Label: View>: View {
    private let action: () -> ()
    private let label: () -> Label
    private let type: ButtonType
    
    @State private var isPressed: Bool = false
    @Binding var state: ButtonState
    
    init(action: @escaping () -> (),
         @ViewBuilder label: @escaping () -> Label,
         state: Binding<ButtonState>,
         type: ButtonType = ButtonType(size: .large, shape: .square)) {
        self.action = action
        self.label = label
        self._state = state
        self.type = type
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                label()
            }
            .allowsHitTesting(false)
        }
        .buttonStyle(SsangButtonStyle(type: type, state: $state))
    }
}
