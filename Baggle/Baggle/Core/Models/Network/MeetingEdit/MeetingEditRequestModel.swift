//
//  MeetingEditRequestModel.swift
//  Baggle
//
//  Created by youtak on 2023/09/12.
//

import Foundation

struct MeetingEditRequestModel: Encodable {
    let meetingID: Int
    let title: String?
    let place: String?
    let meetingTime: Date?
    let memo: String?
}

extension MeetingEditRequestModel {
    init(meetingEditModel: MeetingEditModel) {
        self.init(
            meetingID: meetingEditModel.id,
            title: meetingEditModel.title,
            place: meetingEditModel.place,
            meetingTime: meetingEditModel.date,
            memo: meetingEditModel.memo
        )
    }
}
