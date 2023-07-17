//
//  ContentView.swift
//  promiseDemo
//
//  Created by youtak on 2023/07/17.
//

import SwiftUI

import ComposableArchitecture
import CombineMoya
import Moya

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
