//
//  OnboardingPage.swift
//  Baggle
//
//  Created by youtak on 2023/09/13.
//

import SwiftUI

struct OnboardingPage: View {
    
    let image: Image
    
    var body: some View {
        
        VStack {
            image
                .resizable()
                .scaledToFill()
        }
    }
}

struct OnboardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage(
            image: Image.Onboarding.pageTwo
        )
    }
}
