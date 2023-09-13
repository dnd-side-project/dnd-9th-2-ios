//
//  OnboardingView.swift
//  Baggle
//
//  Created by youtak on 2023/09/13.
//

import SwiftUI

import ComposableArchitecture

struct OnboardingView: View {
    
    let store: StoreOf<OnboardingFeature>

    init(store: StoreOf<OnboardingFeature>) {
        self.store = store
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.gray8)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.gray4)
        UIPageControl.appearance().backgroundColor = .clear
    }
    
    var body: some View {

        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                TabView {
                    OnboardingPage(image: Image.Onboarding.pageOne)
                    OnboardingPage(image: Image.Onboarding.pageTwo)
                    OnboardingPage(image: Image.Onboarding.pageThree)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page)
                .background(Color.white)
                
                
                Button {
                    viewStore.send(.buttonTapped)
                } label: {
                    Text("지금 바로 시작하기")
                }
                .buttonStyle(BagglePrimaryStyle())
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            store: Store(
                initialState: OnboardingFeature.State(),
                reducer: OnboardingFeature()
            )
        )
    }
}
