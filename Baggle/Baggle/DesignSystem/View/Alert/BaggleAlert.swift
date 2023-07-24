//
//  BaggleAlert.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

/**
 - description:

        Baggle Custom Alert 입니다.
 
 - parameters:
    - isPresented: 부모 뷰에서 alert를 보이기 위한 Binding<Bool> 변수
    - title : alert 타이틀
    - description: 타이틀 하단의 설명
    - leftButtonTitle: 왼쪽 버튼 타이틀 (default: 아니오
    - rightButtonTitiel: 오른쪽 버튼 타이틀 (default: 네)
    - rightButtonAction: 오른쪽 버튼 탭했을 때 실행할 액션
 
- note:
 
     @State var isAlertPresented: Bool = false
    
     var body: some View {
        ZStack {
            // 보여질 뷰
                
            BaggleAlert(isPresented: $isAlertPresented, title: "제목입니다") {
                // 오른쪽 버튼 탭했을 때 수행할 액션
            }
        }
     }
 
 */

struct BaggleAlert: View {
    private let screenSize: CGRect = UIScreen.main.bounds
    private var alertWidth: CGFloat {
        screenSize.width - 40
    }

    @Binding private var isPresented: Bool

    private let rightButtonAction: () -> Void
    private var title: String
    private var description: String?
    private var leftButtonTitle: String
    private var rightButtonTitle: String

    init(
        isPresented: Binding<Bool>,
        title: String,
        description: String? = nil,
        leftButtonTitle: String = "아니오",
        rightButtonTitle: String = "네",
        rightButtonAction: @escaping () -> Void
    ) {
        self._isPresented = isPresented
        self.title = title
        self.description = description
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.rightButtonAction = rightButtonAction
    }

    var body: some View {
        ZStack {
            ShadeView(isPresented: $isPresented)

            VStack(spacing: 20) {
                Spacer()

                Text(title)
                    .font(.title3)
                    .multilineTextAlignment(.center)

                if let description {
                    Text(description)
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Spacer()
                }

                HStack {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Text(leftButtonTitle)
                            .frame(width: alertWidth/2, height: 52)
                    }

                    Button {
                        rightButtonAction()
                        isPresented.toggle()
                    } label: {
                        Text(rightButtonTitle)
                            .frame(width: alertWidth/2, height: 52)
                    }
                }
                .frame(width: alertWidth, height: 52)
            }
            .padding()
            .frame(width: alertWidth)
            .frame(minHeight: screenSize.height * 0.2,
                   maxHeight: screenSize.height * 0.24)
            .background(.white)
            .cornerRadius(20)
            .opacity(isPresented ? 1 : 0)
            .transition(.opacity.animation(.easeInOut))
            .animation(.easeInOut(duration: 0.2), value: self.isPresented)
        }
    }
}
