//
//  MeetingCreateRequestModel.swift
//  Baggle
//
//  Created by youtak on 2023/08/16.
//

import Foundation

struct MeetingCreateRequestModel: Encodable {
    let title: String
    let place: String
    let meetingTime: Date
    let memo: String?
}

extension MeetingCreateRequestModel {
    init?(meetingCreateModel: MeetingCreateModel) {
        guard let title = meetingCreateModel.title,
              let place = meetingCreateModel.place,
              let meetingTime = meetingCreateModel.time
        else {
            return nil
        }
        self.init(
            title: title,
            place: place,
            meetingTime: meetingTime,
            memo: meetingCreateModel.memo
        )
    }
}
