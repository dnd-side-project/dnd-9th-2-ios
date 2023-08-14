//
//  BaggleAlert.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

import ComposableArchitecture

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

struct BaggleAlertOneButton: View {
    
    private let screenSize: CGRect = UIScreen.main.bounds
    private var alertWidth: CGFloat {
        screenSize.width - 40
    }
    
    @Binding var isPresented: Bool
    
    private var title: String
    private var description: String?
    private var buttonTitle: String
    private var buttonAction: (() -> Void)?
    
    init(
        isPresented: Binding<Bool>,
        title: String,
        description: String? = nil,
        buttonTitle: String,
        buttonAction: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        ZStack {
            ShadeView(isPresented: $isPresented)
            
            VStack(spacing: 40) {
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.system(size: 20))
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
                        buttonAction?()
                        isPresented.toggle()
                    } label: {
                        Text(buttonTitle)
                            .frame(width: alertWidth/2, height: 52)
                    }
                    .buttonStyle(
                        BagglePrimaryStyle(size: .medium)
                    )
                }
                .frame(width: alertWidth, height: 54)
            }
            .padding(.top, 52)
            .padding(.bottom, 20)
            .frame(width: alertWidth)
            .background(.white)
            .cornerRadius(20)
            .opacity(self.isPresented ? 1 : 0)
            .transition(.opacity.animation(.easeInOut))
            .animation(.easeInOut(duration: 0.2), value: self.isPresented)
        }
    }
}

struct BaggleAlertTwoButton: View {
    
    private let screenSize: CGRect = UIScreen.main.bounds
    private var alertWidth: CGFloat {
        screenSize.width - 40
    }
    
    @Binding var isPresented: Bool
    
    private var title: String
    private var description: String?
    private var leftButtonTitle: String
    private var rightButtonTitle: String
    private let leftButtonAction: (() -> Void)?
    private let rightButtonAction: () -> Void
    
    init(
        isPresented: Binding<Bool>,
        title: String,
        description: String? = nil,
        leftButtonTitle: String = "취소",
        rightButtonTitle: String = "네",
        leftButtonAction: (() -> Void)? = nil,
        rightButtonAction: @escaping () -> Void
    ) {
        self._isPresented = isPresented
        self.title = title
        self.description = description
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
    }
    
    var body: some View {
        ZStack {
            ShadeView(isPresented: $isPresented)
            
            VStack(spacing: 40) {
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.system(size: 20))
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
                            .foregroundColor(.gray7)
                            .frame(width: alertWidth/2, height: 52)
                    }
                    .buttonStyle(BagglePrimaryStyle(size: .small))
                    
                    Button {
                        rightButtonAction()
                        isPresented.toggle()
                    } label: {
                        Text(rightButtonTitle)
                            .frame(width: alertWidth/2, height: 52)
                    }
                    .buttonStyle(
                        BagglePrimaryStyle(size: .small)
                    )
                }
                .frame(width: alertWidth, height: 54)
            }
            .padding(.top, 52)
            .padding(.bottom, 20)
            .frame(width: alertWidth)
            .background(.white)
            .cornerRadius(20)
            .opacity(self.isPresented ? 1 : 0)
            .transition(.opacity.animation(.easeInOut))
            .animation(.easeInOut(duration: 0.2), value: self.isPresented)
        }
    }
}
