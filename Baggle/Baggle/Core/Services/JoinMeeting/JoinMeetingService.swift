//
//  JoinMeetingService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/11.
//

import Foundation

import ComposableArchitecture

struct JoinMeetingService {
    var fetchMeetingInfo: (_ meetingID: Int) async -> JoinMeetingState
}

extension JoinMeetingService: DependencyKey {
    
    static var liveValue = Self { _ in
        do {
            return try await JoinMeetingRepository().mockJoinMeetingState()
        } catch {
            return JoinMeetingState.joined
        }
    }
}

extension DependencyValues {
    var joinMeetingService: JoinMeetingService {
        get { self[JoinMeetingService.self] }
        set { self[JoinMeetingService.self] = newValue }
    }
}

struct JoinMeetingRepository {
    func mockJoinMeetingState() async throws -> JoinMeetingState {
        return try await withCheckedThrowingContinuation({ continuation in
            let info = JoinMeeting(meetingId: 0,
                                   title: "수빈님네 집들이",
                                   place: "유탁님 없는 잠실",
                                   date: "2023년 10월 10일",
                                   time: "15:30")
            continuation.resume(returning: .enable(info))
//            continuation.resume(returning: .expired)
//            continuation.resume(returning: .joined)
        })
    }
}
