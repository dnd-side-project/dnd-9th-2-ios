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
        switch imageState {
        case .empty:
            Image(systemName: "plus")
                .font(.system(size: 40))
                .foregroundColor(.blue)
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
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileImageView(imageState: .empty)
                .previewLayout(.sizeThatFits)
        }
    }
}
