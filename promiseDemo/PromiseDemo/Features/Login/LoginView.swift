//
//  LoginView.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import SwiftUI

struct LoginView: View {
    var body: some View {

        VStack {

            Spacer()

            Circle()
                .fill(Color.blue)
                .frame(width: 200, height: 200)
                .padding()

            Spacer()

            Button {
                print("login")
            } label: {
                HStack {

                    Spacer()

                    Text("로그인")
                        .font(.title)
                        .padding()

                    Spacer()
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)

            Spacer()
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
