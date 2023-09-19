//
//  FeedReportView.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/18.
//

import SwiftUI

import ComposableArchitecture

struct FeedReportView: View {

    let store: StoreOf<FeedReportFeature>

    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("신고")
                        .font(.Baggle.body1)
                    
                    Text("이 게시물을 신고하는 이유가 무엇인가요?")
                        .font(.Baggle.body2)
                        .foregroundColor(.gray6)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(ReportType.allCases, id: \.self) { type in
                            Text(type.description)
                                .font(.Baggle.body2)
                                .padding(.vertical, 10)
                                .onTapGesture {
                                    viewStore.send(.reportTypeSelected(type))
                                }
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
            .onDisappear {
                viewStore.send(.disappear)
            }
        }
    }
}

struct FeedReportView_Previews: PreviewProvider {
    static var previews: some View {
        FeedReportView(
            store: Store(
                initialState: FeedReportFeature.State(),
                reducer: FeedReportFeature()
            )
        )
    }
}
