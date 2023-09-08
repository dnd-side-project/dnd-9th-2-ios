//
//  BaggleAlertOneButton.swift
//  Baggle
//
//  Created by youtak on 2023/09/06.
//

import SwiftUI

struct BaggleAlertOneButton: View {
    
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
                .padding(.horizontal, 20)
                
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
        }
    }
}

struct BaggleAlertOneButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray11.opacity(0.7)
            
            BaggleAlertOneButton(
                isPresented: .constant(true),
                title: "버튼 하나짜리 Alert입니다.",
                buttonTitle: "확인"
            )
        }
    }
}
