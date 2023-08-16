//
//  MeetingSuccessModel.swift
//  Baggle
//
//  Created by youtak on 2023/08/16.
//

import Foundation

struct MeetingSuccessModel: Equatable {
    let id: Int
    let title: String
    let place: String
    let time: String
}

extension MeetingSuccessModel {
    init(id: Int, meetingCreateRequestModel: MeetingCreateRequestModel) {
        let date = meetingCreateRequestModel.meetingTime.koreanDate()
        let time = meetingCreateRequestModel.meetingTime.hourMinute()
        
        self.init(
            id: id,
            title: meetingCreateRequestModel.title,
            place: meetingCreateRequestModel.place,
            time: date + " " + time
        )
    }
}
