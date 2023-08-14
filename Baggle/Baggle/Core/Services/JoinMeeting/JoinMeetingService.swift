//
//  JoinMeetingService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/11.
//

import Foundation

import ComposableArchitecture

struct JoinMeetingService {
    var fetchMeetingInfo: (_ meetingID: Int) async -> JoinMeetingStatus
    var postJoinMeeting: (_ meetingID: Int) async -> JoinMeetingResultStatus
}

extension JoinMeetingService: DependencyKey {
    
    static let networkService = BaseService<MemberAPI>()
    
    static var liveValue = Self { meetingID in
        do {
            let accessToken = try KeychainManager.shared.readUserToken().accessToken
            let data: JoinMeetingInfoEntity = try await networkService.request(
                .fetchMeetingInfo(
                    meetingID: meetingID,
                    token: accessToken
                )
            )
            return JoinMeetingStatus.enable(data.toDomain())
        } catch let error {
            guard let error = error as? APIError else { return .fail(.network) }
            if error == .duplicatedJoinMeeting {
                return JoinMeetingStatus.joined
            } else {
                return JoinMeetingStatus.expired
            }
        }
    } postJoinMeeting: { meetingID in
        do {
            let accessToken = try KeychainManager.shared.readUserToken().accessToken
            let _: Int = try await networkService.requestWithNoResult(
                .postJoinMeeting(
                    meetingID: meetingID,
                    token: accessToken
                )
            )
            return JoinMeetingResultStatus.success
        } catch let error {
            guard let error = error as? APIError else { return .fail(.network) }
            return JoinMeetingResultStatus.fail(error)
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
    func mockJoinMeetingState() async throws -> JoinMeetingStatus {
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
