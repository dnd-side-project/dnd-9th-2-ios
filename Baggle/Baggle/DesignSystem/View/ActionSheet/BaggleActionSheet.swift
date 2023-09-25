//
//  BaggleActionSheet.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/01.
//

import SwiftUI

struct BaggleActionSheet<Content: View>: View {
    
    @Binding var isShowing: Bool
    
    private let action: Content
    
    init(isShowing: Binding<Bool>, @ViewBuilder action: @escaping () -> Content) {
        self._isShowing = isShowing
        self.action = action()
    }
    
    var body: some View {
        VStack {
            if isShowing {
                VStack(spacing: 15) {
                    Spacer()
                    
                    // 액션 버튼
                    VStack(spacing: 0) {
                        action
                    }
                    .buttonStyle(ActionButtonStyle())
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .background(.white)
                    .cornerRadius(8)
                    
                    // 취소 버튼
                    Button("닫기") {
                        isShowing = false
                    }
                    .buttonStyle(CancelActionButtonStyle())
                }
                .transition(.move(edge: .bottom))
                .onReceive(NotificationCenter.default.publisher(for: .actionSheetDismiss)) { _ in
                    isShowing = false
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isShowing)
    }
}
