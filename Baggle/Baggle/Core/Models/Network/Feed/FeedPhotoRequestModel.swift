//
//  FeedPhotoRequestModel.swift
//  Baggle
//
//  Created by youtak on 2023/08/15.
//

import Foundation

struct FeedPhotoRequestModel: Encodable {
    let participation: FeedParticipationModel
    let feedImage: Data
}
