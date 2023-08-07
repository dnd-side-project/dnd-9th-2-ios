//
//  ProfileImageView.swift
//  Baggle
//
//  Created by youtak on 2023/07/27.
//

import SwiftUI

struct ProfileImageView: View {
    let imageState: AlbumImageState

    var body: some View {
        ZStack {
            switch imageState {
            case .empty:
                ZStack {}
            case .loading:
                ProgressView()
            case .success(let image):
                image.resizable()
            case .failure:
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
            }
        }
        .scaledToFill()
        .clipShape(Circle())
        .frame(width: 160, height: 160)
        .background {
            Circle()
                .tint(Color.grayF5)
        }
        .overlay(alignment: .bottomTrailing) {
            ZStack {
                Circle()
                    .foregroundColor(.primaryNormal)
                    .frame(width: 30, height: 30)

                Image.Icon.camera
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.primaryNormal)
            }
            .offset(x: -9, y: -9)
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileImageView(imageState: .success(Image("sampleImage")))
                .previewLayout(.sizeThatFits)
        }
    }
}
