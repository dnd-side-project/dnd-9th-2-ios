//
//  MeetingEdit.swift
//  Baggle
//
//  Created by youtak on 2023/08/31.
//

import Foundation

struct MeetingEditModel: Equatable {
    let id: Int
    let title: String
    let place: String
    let date: Date
    let memo: String
}

extension MeetingEditModel {
    
    // title
    func update(title: String) -> MeetingEditModel {
        MeetingEditModel(
            id: self.id,
            title: title,
            place: self.place,
            date: self.date,
            memo: self.memo
        )
    }
    
    // place
    func update(place: String) -> MeetingEditModel {
        MeetingEditModel(
            id: self.id,
            title: self.title,
            place: place,
            date: self.date,
            memo: self.memo
        )
    }

    // date
    func update(date: Date) -> MeetingEditModel {
        MeetingEditModel(
            id: self.id,
            title: self.title,
            place: self.place,
            date: date,
            memo: self.memo
        )
    }
    
    // memo
    func update(memo: String) -> MeetingEditModel {
        MeetingEditModel(
            id: self.id,
            title: self.title,
            place: self.place,
            date: self.date,
            memo: memo
        )
    }
}
