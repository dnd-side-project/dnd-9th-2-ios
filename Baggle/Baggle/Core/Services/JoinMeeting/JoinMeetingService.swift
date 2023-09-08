//
//  JoinMeetingService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/11.
//

import Foundation

import ComposableArchitecture

struct JoinMeetingService {
    var fetchMeetingInfo: (_ meetingID: Int) async -> JoinMeetingResult
    var postJoinMeeting: (_ meetingID: Int) async -> JoinMeetingPostResult
}

extension JoinMeetingService: DependencyKey {
    
    static let networkService = NetworkService<MemberAPI>()
    
    static var liveValue = Self { meetingID in
        do {
            return try await Task.retrying {
                guard let accessToken = UserManager.shared.accessToken else {
                    return .fail(.network)
                }
                
                let data: JoinMeetingInfoEntity = try await networkService.request(
                    .fetchMeetingInfo(
                        meetingID: meetingID,
                        token: accessToken
                    )
                )
                
                return JoinMeetingResult.enable(data.toDomain())
            }.value
        } catch let error {
            guard let error = error as? APIError else { return .fail(.network) }
            if error == .duplicatedJoinMeeting {
                return JoinMeetingResult.joined
            } else {
                return JoinMeetingResult.expired(error)
            }
        }
    } postJoinMeeting: { meetingID in
        do {
            return try await Task.retrying {
                guard let accessToken = UserManager.shared.accessToken else {
                    return .fail(.network)
                }
                
                try await networkService.requestWithNoResult(
                    .postJoinMeeting(
                        meetingID: meetingID,
                        token: accessToken
                    )
                )
                
                return JoinMeetingPostResult.success
            }.value
        } catch let error {
            guard let error = error as? APIError else { return .fail(.network) }
            return JoinMeetingPostResult.fail(error)
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
    func mockJoinMeetingState() async throws -> JoinMeetingResult {
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
