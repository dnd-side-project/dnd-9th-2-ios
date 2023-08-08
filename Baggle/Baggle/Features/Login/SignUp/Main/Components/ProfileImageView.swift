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
                Image.Profile.profilDefault
                    .resizable()
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
        .frame(width: 160, height: 160)
        .background {
            Color.grayF5
            
            RoundedRectangle(cornerRadius: 100)
                .stroke(Color.grayD9, lineWidth: 1)
        }
        .clipShape(Circle())
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
            ProfileImageView(imageState: .empty)

            ProfileImageView(imageState: .success(Image("sampleImage")))
            
            ProfileImageView(imageState: .loading)
            
            ProfileImageView(imageState: .failure)
        }
        .previewLayout(.sizeThatFits)
    }
}
