//
//  Feed.swift
//  Baggle
//
//  Created by youtak on 2023/08/10.
//

/// 모임 인증 피드
struct Feed: Equatable {
    let id: Int
    let userID: Int
    let username: String
    let userImageURL: String?
    let feedImageURL: String
}
