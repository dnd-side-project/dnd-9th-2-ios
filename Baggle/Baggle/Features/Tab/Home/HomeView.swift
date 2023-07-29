//
//  HomeView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {

    let store: StoreOf<HomeFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 20) {
                    Text("Home View 입니다")

                    Button {
                        viewStore.send(.shareButtonTapped)
                    } label: {
                        Text("카카오톡 공유하기")
                    }
                    .buttonStyle(BagglePrimaryStyle())

                    BaggleTextField(
                        store: self.store.scope(
                            state: \.textFieldState,
                            action: HomeFeature.Action.textFieldAction),
                        placeholder: "place holder"
                    )
                    .padding()

                    Text("textField: \(viewStore.textFieldState.text)")

                    Button("alert 띄우기") {
                        viewStore.send(.alertButtonTapped)
                    }
                }

                BaggleAlert(isPrsented: Binding(
                    get: { viewStore.state.isAlertPresented },
                    set: { _ in
                        viewStore.send(.alertButtonTapped)
                    }), title: "Alert입니다") {
                        print("Alert 인데용")
                }
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
