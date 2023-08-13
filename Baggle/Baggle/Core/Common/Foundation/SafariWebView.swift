//
//  SafariWebView.swift
//  Baggle
//
//  Created by youtak on 2023/08/12.
//

import SafariServices
import SwiftUI

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}
