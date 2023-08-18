//
//  FeedPhotoRequestModel.swift
//  Baggle
//
//  Created by youtak on 2023/08/15.
//

import SwiftUI

struct FeedPhotoRequestModel: Encodable {
    let memberInfo: FeedMemberInfoRequestModel
    let feedImage: Data
}

extension FeedPhotoRequestModel {
    init?(memberID: Int, time: Date, feedImage: UIImage) {
        guard let compressedImage = feedImage
            .compress(imageSize: .large)
            .jpegData(compressionQuality: Const.Image.jpegCompression)
        else {
            return nil
        }
        
        self.init(
            memberInfo: FeedMemberInfoRequestModel(
                memberID: memberID,
                authorizationTime: time
            ),
            feedImage: compressedImage
        )
    }
}
