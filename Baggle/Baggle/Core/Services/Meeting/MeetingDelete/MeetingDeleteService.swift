//
//  MeetingDeleteService.swift
//  Baggle
//
//  Created by youtak on 2023/09/07.
//

import Foundation

import ComposableArchitecture

struct MeetingDeleteService {
    var delegateOwner: (_ fromMemberID: Int, _ toMemberID: Int) async -> MeetingDeleteResult
}

extension MeetingDeleteService: DependencyKey {
    
    static var liveValue = Self { fromMemberID, toMemberID in
        return .successDelegate
    }
    
}

extension DependencyValues {
    var meetingDeleteService: MeetingDeleteService {
        get { self[MeetingDeleteService.self] }
        set { self[MeetingDeleteService.self] = newValue }
    }
}
