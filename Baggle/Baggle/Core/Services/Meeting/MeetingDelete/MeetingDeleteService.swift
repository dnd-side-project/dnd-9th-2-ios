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
    var leave: (_ memberID: Int) async -> MeetingDeleteResult
    var delete: (_ meetingID: Int) async -> MeetingDeleteResult
}

extension MeetingDeleteService: DependencyKey {
    
    static let networkMemberService = NetworkService<MemberAPI>()
    static let networkMeetingService = NetworkService<MeetingAPI>()
    
    static var liveValue = Self { fromMemberID, toMemberID in
        do {
            guard let accessToken = UserManager.shared.accessToken else {
                return .userError
            }
            
            try await networkMemberService.requestWithNoResult(
                .delegateOwner(
                    fromMemberID: fromMemberID,
                    toMemberID: toMemberID,
                    token: accessToken
                )
            )
            
            return .successDelegate
        } catch {
            return .networkError
        }
    } leave: { memberID in
        do {
            guard let accessToken = UserManager.shared.accessToken else {
                return .userError
            }
            
            try await networkMemberService.requestWithNoResult(
                .leaveMeeting(
                    memberID: memberID,
                    token: accessToken
                )
            )
            
            return .successLeave
        } catch {
            return .networkError
        }
    } delete: { meetingID in
        do {
            guard let accessToken = UserManager.shared.accessToken else {
                return .userError
            }
            
            try await networkMeetingService.requestWithNoResult(
                .deleteMeeting(
                    meetingID: meetingID,
                    token: accessToken
                )
            )
            
            return .successDelete
        } catch {
            return .networkError
        }
    }
}

extension DependencyValues {
    var meetingDeleteService: MeetingDeleteService {
        get { self[MeetingDeleteService.self] }
        set { self[MeetingDeleteService.self] = newValue }
    }
}
