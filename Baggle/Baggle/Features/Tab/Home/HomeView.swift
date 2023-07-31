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
            NavigationStack {
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
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .moveMeetingDetail),
                           perform: { noti in
                    print("noti: \(noti)")
                    viewStore.send(.moveToMeetingDetail)
                })
                .navigationDestination(
                    isPresented: Binding(
                        get: { viewStore.showMeetingDetail },
                        set: { _ in viewStore.send(.moveToMeetingDetail) })
                ) {
                    MeetingDetailView(
                        store: Store(
                            initialState: MeetingDetailFeature.State(),
                            reducer: MeetingDetailFeature())
                    )
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
