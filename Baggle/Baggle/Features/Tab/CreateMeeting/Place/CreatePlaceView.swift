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
            VStack {
                VStack(alignment: .leading, spacing: 16) {

                    NumberListView(data: CreateStatus.array, selectedStatus: .place)

                    Text("약속 장소는 어디인가요?")
                        .font(.title2)

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
                }
                .padding()

                Spacer()

                Button {
                    viewStore.send(.nextButtonTapped)
                } label: {
                    Text("다음")
                }
                .padding(.bottom, 10)
                .buttonStyle(BagglePrimaryStyle())
                .disabled(viewStore.state.nextButtonDisabled)
            }
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
