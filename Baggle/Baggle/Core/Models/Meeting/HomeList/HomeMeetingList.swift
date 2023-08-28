//
//  Home.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

struct HomeMeetingList: Equatable {
    let progressCount: Int
    let completedCount: Int
    let meetings: [Meeting]?
}
