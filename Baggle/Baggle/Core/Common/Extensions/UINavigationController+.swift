//
//  UINavigationController+.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/08.
//

import SwiftUI

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}
