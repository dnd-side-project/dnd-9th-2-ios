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

            ZStack {
                if viewStore.isLoading {
                    LoadingView()
                }
                
                VStack {
                    Text("마이페이지입니다.")

                    Button {
                        viewStore.send(.withdrawButtonTapped)
                    } label: {
                        HStack {

                            Spacer()

                            Text("회원탈퇴")
                                .font(.title)
                                .padding()

                            Spacer()
                        }
                    }
                    .buttonStyle(BagglePrimaryStyle())
                }
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
