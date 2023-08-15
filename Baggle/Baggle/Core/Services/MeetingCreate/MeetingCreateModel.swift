//
//  MeetingCreateModel.swift
//  Baggle
//
//  Created by youtak on 2023/08/15.
//

import Foundation

struct MeetingCreateModel: Equatable {
    let title: String?
    let place: String?
    let meetingTime: Date?
    let memo: String?
}

extension MeetingCreateModel {
    func update(title: String) -> MeetingCreateModel {
        MeetingCreateModel(
            title: title,
            place: self.place,
            meetingTime: self.meetingTime,
            memo: self.memo
        )
    }
    
    func update(place: String) -> MeetingCreateModel {
        MeetingCreateModel(
            title: self.title,
            place: place,
            meetingTime: self.meetingTime,
            memo: self.memo
        )
    }
    
    func update(meetingTime: Date) -> MeetingCreateModel {
        MeetingCreateModel(
            title: self.title,
            place: self.place,
            meetingTime: meetingTime,
            memo: self.memo
        )
    }
    
    func update(memo: String) -> MeetingCreateModel {
        MeetingCreateModel(
            title: self.title,
            place: self.place,
            meetingTime: self.meetingTime,
            memo: memo
        )
    }
}
