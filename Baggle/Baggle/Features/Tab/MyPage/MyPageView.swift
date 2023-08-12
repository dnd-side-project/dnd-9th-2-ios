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
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            List {
                
                // MARK: - 프로필
                
                Section {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            KFImage(URL(string: viewStore.user.profileImageURL ?? ""))
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
                                Text(viewStore.user.name)
                                    .font(.Baggle.subTitle)
                                    .foregroundColor(.gray11)
                                
                                PlatformLogoView(platform: viewStore.user.platform)
                            }
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 24)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                }
                .listRowSeparator(.hidden)
                
                // MARK: - 일반 설정
                
                Section {
                    SettingListRow(text: "알림 설정") {
                        viewStore.send(.notificationSettingButtonTapped)
                    }
                    
                    SettingListRow(text: "개인정보 처리방침") {
                        viewStore.send(.privacyPolicyButtonTapped)
                    }
                    
                    SettingListRow(text: "서비스 이용약관") {
                        viewStore.send(.termsOfServiceButtonTapped)
                    }
                } header: {
                    SettingListHeader(text: "일반 설정")
                }
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                
                // MARK: - 계정
                
                Section {
                    SettingListRow(text: "계정 탈퇴", isArrow: false) {
                        print("서비스 이용약솬")
                    }
                } header: {
                    SettingListHeader(text: "계정")
                }
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
            .listRowInsets(EdgeInsets())
            .listStyle(.plain)
            .fullScreenCover(
                isPresented: viewStore.binding(
                    get: \.presentSafariView,
                    send: { _ in MyPageFeature.Action.presentSafariView }
                )
            ) {
                if let url = URL(string: viewStore.state.safariURL) {
                    SafariWebView(url: url)
                }
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
