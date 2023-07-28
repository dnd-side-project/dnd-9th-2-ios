//
//  BaggleButtonStyle.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

struct BagglePrimaryStyle: ButtonStyle {

    let size: ButtonSize
    let shape: ButtonShape

    private let foregroundColor: Color = .white
    private let backgroundColor: Color = .blue

    init(size: ButtonSize = .large, shape: ButtonShape = .square) {
        self.size = size
        self.shape = shape
    }

    @Environment(\.isEnabled) private var isEnabled

    private func foregroundColor(_ isPressed: Bool) -> Color {
        if !isEnabled {
            return foregroundColor
        } else if isPressed {
            return foregroundColor.opacity(0.5)
        } else {
            return foregroundColor
        }
    }

    private func backgroundColor(_ isPressed: Bool) -> Color {
        if !isEnabled {
            return backgroundColor
        } else if isPressed {
            return backgroundColor.opacity(0.5)
        } else {
            return backgroundColor
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.main.bounds.width * size.ratio, height: 62)
            .cornerRadius(shape.radius)
            .foregroundColor(foregroundColor(configuration.isPressed))
            .background(backgroundColor(configuration.isPressed))
            .cornerRadius(shape.radius)
            .shadow(color: Color(.systemGray4).opacity(0.6), radius: 4)
    }
}
