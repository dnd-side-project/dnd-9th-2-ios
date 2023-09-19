//
//  MyPage.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

import Foundation
import MessageUI

import ComposableArchitecture
import Kingfisher

struct MyPageView: View {
    
    let store: StoreOf<MyPageFeature>
    private let mailComposeDelegate = MailDelegate()
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                
                // MARK: - 프로필
                
                Section {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            CircleProfileView(
                                imageUrl: viewStore.user.profileImageURL,
                                size: .xxLarge
                            )
                            
                            HStack(alignment: .top, spacing: 6) {
                                Text(viewStore.user.name)
                                    .font(.Baggle.subTitle1)
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
                .listSectionSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                
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
                    
                    SettingListRow(text: "문의하기") {
                        self.presentMailView()
                    }
                } header: {
                    SettingListHeader(text: "일반 설정")
                }
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                
                // MARK: - 계정
                
                Section {
                    SettingListRow(text: "로그아웃", isArrow: false) {
                        viewStore.send(.logoutButtonTapped)
                    }
                    SettingListRow(text: "계정 탈퇴", isArrow: false) {
                        viewStore.send(.withdrawButtonTapped)
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
            .onAppear {
                viewStore.send(.onAppear)
            }
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

extension MyPageView {
    
    private class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            controller.dismiss(animated: true)
        }
    }
    
    func presentMailView() {
        guard MFMailComposeViewController.canSendMail() else { return }
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
                as? String else { return }
        
        let rootVC = UIApplication.shared.currentKeyWindow?.rootViewController
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = mailComposeDelegate
        
        composeVC.setToRecipients(["kingzzangssang@gmail.com"])
        composeVC.setSubject("Baggle 문의 사항")
        composeVC.setMessageBody("""
        
        Device: \(UIDevice.iPhoneModel)
        OS Version: \(UIDevice.iOSVersion)
        App Version: \(appVersion)
        ----------------------------
        
        문의 사항을 작성해주세요.
        
        """, isHTML: false)
        
        rootVC?.present(composeVC, animated: true)
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
