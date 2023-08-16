//
//  FeedParticipationModel.swift
//  Baggle
//
//  Created by youtak on 2023/08/15.
//

import Foundation

struct FeedMemberInfoModel: Encodable {
    let memberID: Int
    let authorizationTime: Date
    
    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case authorizationTime
    }
}
