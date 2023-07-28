//
//  MyPage.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

import ComposableArchitecture

struct MyPageView: View {

    let store: StoreOf<MyPageFeature>

    @State var textfield: String = ""

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in

            VStack {
                Text("마이페이지입니다. 마이페이지입니다. 마이페이지입니다.")

                Button {
                    viewStore.send(.logoutMyPage)
                } label: {
                    HStack {

                        Spacer()

                        Text("로그아웃")
                            .font(.title)
                            .padding()

                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(
            store: Store(
                initialState: MyPageFeature.State(),
                reducer: MyPageFeature()
            )
        )
    }
}
