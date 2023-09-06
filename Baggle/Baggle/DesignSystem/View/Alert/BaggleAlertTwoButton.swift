//
//  BaggleAlertTwoButton.swift
//  Baggle
//
//  Created by youtak on 2023/09/06.
//

import SwiftUI

struct BaggleAlertTwoButton: View {
    
    private var alertWidth: CGFloat {
        screenSize.width - 40
    }
    
    private var buttonWidth: CGFloat {
        (alertWidth - 48) / 2
    }
    
    @Binding var isPresented: Bool
    
    private var title: String
    private var description: String?
    private let alertType: RightAlertButtonType
    
    private var leftButtonTitle: String
    private var rightButtonTitle: String
    private let leftButtonAction: (() -> Void)?
    private let rightButtonAction: () -> Void
    
    init(
        isPresented: Binding<Bool>,
        title: String,
        description: String? = nil,
        alertType: RightAlertButtonType = .none,
        leftButtonTitle: String = "취소",
        rightButtonTitle: String = "네",
        leftButtonAction: (() -> Void)? = nil,
        rightButtonAction: @escaping () -> Void
    ) {
        self._isPresented = isPresented
        self.title = title
        self.description = description
        self.alertType = alertType
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.Baggle.subTitle2)
                        .foregroundColor(.gray11)
                        .padding(.vertical, 5)
                    
                    if let description {
                        Text(description)
                            .font(.Baggle.body2)
                            .foregroundColor(.gray8)
                            .padding(.vertical, 4)
                    }
                }
                .multilineTextAlignment(.center)
                
                HStack {
                    Button {
                        leftButtonAction?()
                        isPresented.toggle()
                    } label: {
                        Text(leftButtonTitle)
                            .font(.Baggle.button1)
                            .foregroundColor(.gray7)
                            .frame(width: buttonWidth, height: 52)
                            .background(Color.gray4)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        rightButtonAction()
                        isPresented.toggle()
                    } label: {
                        Text(rightButtonTitle)
                            .font(.Baggle.button1)
                            .foregroundColor(.white)
                            .frame(width: buttonWidth, height: 52)
                            .background(alertType.backgroundColor)
                            .cornerRadius(8)
                    }
                }
                .frame(width: alertWidth, height: 54)
            }
            .padding(.top, 52)
            .padding(.bottom, 20)
            .frame(width: alertWidth)
            .background(.white)
            .cornerRadius(20)
        }
    }
}

struct BaggleAlertTwoButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray11.opacity(0.7)
            
            BaggleAlertTwoButton(
                isPresented: .constant(true),
                title: "2개 버튼 Alert입니다",
                rightButtonAction: {
                    print("버튼 액션")
                }
            )
        }
    }
}
