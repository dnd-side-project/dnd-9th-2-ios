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
    init(id: Int, requestModel: MeetingCreateRequestModel) {
        let date = requestModel.meetingTime.koreanDate()
        let time = requestModel.meetingTime.hourMinute()
        
        self.init(
            id: id,
            title: requestModel.title,
            place: requestModel.place,
            time: date + " " + time
        )
    }
}
