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
            VStack(alignment: .leading) {
                
                HStack {
                    Spacer()

                    Button {
                        viewStore.send(.cancelButtonTapped)
                    } label: {
                        Image.Icon.close
                    }
                }
                
                VStack(spacing: 2) {
                    Text("게시글 신고하기")
                        .font(.Baggle.subTitle2)
                        .foregroundColor(.gray11)
                    
                    Text("신고하는 이유가 무엇인가요?")
                        .font(.Baggle.body2)
                        .foregroundColor(.gray8)
                }
                .padding(.bottom, 34)
                
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(ReportType.allCases, id: \.self) { type in
                        HStack {
                            
                            if let selectedType = viewStore.selectedType,
                               selectedType == type {
                                Image.Icon.checkCircle
                            } else {
                                Image.Icon.emptyCircle
                            }
                            
                            Text(type.description)
                                .font(.baggleFont(size: 18, weight: .medium))
                                .foregroundColor(.gray11)
                        }
                        .onTapGesture {
                            viewStore.send(.reportTypeSelected(type))
                        }
                    }
                }
                
                Spacer()
                
                Button("신고하기") {
                    viewStore.send(.reportButtonTapped)
                }
                .buttonStyle(BagglePrimaryStyle())
                .disabled(viewStore.reportButtonDisabled)
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
