//
//  FeedPhotoStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/15.
//

import Foundation

enum FeedPhotoStatus: Equatable {
    case success(Feed)
    case error
    case userError
}
