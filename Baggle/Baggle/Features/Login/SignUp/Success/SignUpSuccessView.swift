//
//  SignUpProfileImageView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import SwiftUI

import ComposableArchitecture

struct SignUpSuccessView: View {

    let store: StoreOf<SignUpSuccessFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack {
                description
                    .padding(.top, 46) // 툴 바 높이

                Image.Illustration.celebration
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 56)
                    .padding(.top, 90)
                    .overlay {
                        BadgeView(
                            text: "가입축하",
                            foregroundColor: .white,
                            backgroundColor: .baggleRed
                        )
                        .rotationEffect(.degrees(10))
                        .offset(x: 80, y: -95)
                    }

                Spacer()

                Button {
                    viewStore.send(.nextButtonTapped)
                } label: {
                    Text("시작하기")
                        .padding()
                }
                .buttonStyle(BagglePrimaryStyle())
            }
            .navigationBarBackButtonHidden()
        }
    }
}

extension SignUpSuccessView {

    @ViewBuilder
    private var description: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 4) {
                HStack(spacing: 0) {
                    Image.BaggleText.profile
                        .renderingMode(.template)
                    
                    Text("에 오신 걸")
                }
                
                Text("환영합니다!")
            }
            .fontWithLineSpacing(fontType: .subTitle1)
            .foregroundColor(.primaryNormal)
            .padding(.vertical, 8)

            Text("Baggle에서 특별한 추억을 만들어 보세요.")
                .font(.Baggle.body2)
                .foregroundColor(.gray6)
        }
        .multilineTextAlignment(.center)
    }
}

struct SignUpProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpSuccessView(
                store: Store(
                    initialState: SignUpSuccessFeature.State(),
                    reducer: SignUpSuccessFeature()
                )
            )
        }
    }
}
