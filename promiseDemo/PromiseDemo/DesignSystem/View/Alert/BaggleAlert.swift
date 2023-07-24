//
//  BaggleAlert.swift
//  PromiseDemo
//
//  Created by 양수빈 on 2023/07/23.
//

import SwiftUI

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
