//
//  FeedParticipationModel.swift
//  Baggle
//
//  Created by youtak on 2023/08/15.
//

import Foundation

struct FeedParticipationModel: Encodable {
    let participationID: Int
    let authorizationTime: Date
    
    enum CodingKeys: String, CodingKey {
        case participationID = "participationId"
        case authorizationTime
    }
}
