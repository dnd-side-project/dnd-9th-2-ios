//
//  HomeView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {

    @State var shareButtonState: ButtonState = .enable

    let store: StoreOf<HomeFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Text("Home View 입니다")

                BaggleButton(action: {
                    viewStore.send(.shareButtonTapped)
                }, label: {
                    Text("카카오톡 공유하기")
                }, state: $shareButtonState)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            store: Store(
                initialState: HomeFeature.State(),
                reducer: HomeFeature()._printChanges()
            )
        )
    }
}
