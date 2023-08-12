//
//  MyPage.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct MyPageView: View {
    
    let store: StoreOf<MyPageFeature>
    
    @State var textfield: String = ""
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            List {
                Section {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            KFImage(URL(string: ""))
                                .placeholder({ _ in
                                    Image.Profile.profilDefault
                                        .resizable()
                                })
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(50)
                                .clipped()
                            
                            HStack(alignment: .top, spacing: 6) {
                                Text("바글이")
                                    .font(.Baggle.subTitle)
                                    .foregroundColor(.gray11)
                                
                                Image.Icon.kakao
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 14)
                                    .padding(4)
                                    .background(.yellow)
                                    .cornerRadius(30)
                            }
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 24)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                }
                .listRowSeparator(.hidden)
                
                
                
                Section {
                    SettingListRow(text: "알림 설정") {
                        print("알림 설정")
                    }
                    
                    SettingListRow(text: "개인정보 처리방침") {
                        print("개인정보 처리방침")
                    }
                    
                    SettingListRow(text: "서비스 이용약관") {
                        print("서비스 이용약솬")
                    }
                } header: {
                    SettingListHeader(text: "일반 설정")
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                
                Section {
                    SettingListRow(text: "계정 탈퇴", isArrow: false) {
                        print("서비스 이용약솬")
                    }
                } header: {
                    SettingListHeader(text: "계정")
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
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
