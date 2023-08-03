//
//  Extensions+View.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

extension View {

    // MARK: - drawUnderline

    /**
     - description:
            
            View 하단에 선을 그려주는 메서드입니다.
            textField 하단에 선을 그리는 용도로 사용되고 있습니다.
     
     - parameters:
        - spacing: view 하단으로부터 거리
        - height : 선의 두께
        - color : 선의 색상
     
     - note:
     
            HStack { ... }
                .drawUnderline()
     */

    func drawUnderline(
        spacing: CGFloat = 3,
        height: CGFloat = 1,
        color: Color = .gray
    ) -> some View {
        self.modifier(UnderlineView(spacing: spacing, height: height, color: color))
    }
}
