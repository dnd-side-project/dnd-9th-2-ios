//
//  LottieView.swift
//  Baggle
//
//  Created by youtak on 2023/08/18.
//

import SwiftUI

import Lottie

struct LottieView: UIViewRepresentable {
    
    var fileName: String
    var loopMode: LottieLoopMode
    var completion: (() -> Void)?
    var animationView = LottieAnimationView()
    
    init(fileName: String, loopMode: LottieLoopMode, completion: (() -> Void)? = nil) {
        self.fileName = fileName
        self.loopMode = loopMode
        self.completion = completion
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        
        let animation = LottieAnimation.named(fileName)
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = loopMode
        animationView.play { _ in
            self.completion?()
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

extension LottieView {
    init(lottieType: LottieType, completion: (() -> Void)? = nil) {
        self.init(
            fileName: lottieType.filename,
            loopMode: .playOnce,
            completion: completion)
    }
}
