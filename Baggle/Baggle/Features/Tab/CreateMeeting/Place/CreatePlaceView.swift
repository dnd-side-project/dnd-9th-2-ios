//
//  CreateMeetingPlaceView.swift
//  Baggle
//
//  Created by youtak on 2023/07/30.
//

import SwiftUI

import ComposableArchitecture

struct CreatePlaceView: View {

    let store: StoreOf<CreatePlaceFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {

                CreateDescription(createStatus: .place, title: "약속 장소는 어디인가요?")

                BaggleTextField(
                    store: self.store.scope(
                        state: \.textFieldState,
                        action: CreatePlaceFeature.Action.textFieldAction
                    ),
                    placeholder: "ex. 성수역 2번 출구",
                    title: .title("약속 장소를 입력하세요.")
                )
                .submitLabel(.done)
                .onSubmit {
                    viewStore.send(.submitButtonTapped)
                }

                Spacer()

                Button {
                    viewStore.send(.nextButtonTapped)
                } label: {
                    Text("다음")
                }
                .buttonStyle(BagglePrimaryStyle())
                .disabled(viewStore.state.nextButtonDisabled)
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

struct CreateMeetingPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlaceView(
            store: Store(
                initialState: CreatePlaceFeature.State(),
                reducer: CreatePlaceFeature()
            )
        )
    }
}
