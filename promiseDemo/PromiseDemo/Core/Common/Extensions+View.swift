//
//  Extensions+View.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

extension View {
    func drawUnderline(spacing: CGFloat = 3,
                       height: CGFloat = 1,
                       color: Color = .gray) -> some View {
        self.modifier(UnderlineView(spacing: spacing, height: height, color: color))
    }
}
