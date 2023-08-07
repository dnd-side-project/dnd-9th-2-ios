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
            Image(systemName: "camera.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 30))
                .foregroundColor(.primaryNormal)
                .offset(x: -8, y: -8)
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
