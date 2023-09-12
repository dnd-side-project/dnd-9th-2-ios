//
//  MeetingEditSuccessModel.swift
//  Baggle
//
//  Created by youtak on 2023/09/12.
//

import Foundation

struct MeetingEditSuccessModel: Equatable {
    let meetingID: Int
    let title: String
    let place: String
    let meetingTime: Date
    let memo: String?
}
