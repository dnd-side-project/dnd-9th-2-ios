//
//  MeetingDetailService.swift
//  Baggle
//
//  Created by youtak on 2023/08/14.
//

import Foundation

import ComposableArchitecture

struct MeetingDetailService {
    var fetchMeetingDetail: (_ meetingID: Int) async -> MeetingDetailResult
}

extension MeetingDetailService: DependencyKey {
    
    static let networkService = NetworkService<MeetingAPI>()
    
    static var liveValue = Self { meetingID in
        do {
            return try await Task.retrying {
                guard let token = UserManager.shared.accessToken,
                      let username = UserDefaultManager.user?.name else {
                    return MeetingDetailResult.userError
                }
                
                let meetingDetailEntity: MeetingDetailEntity = try await networkService.request(
                    .meetingDetail(meetingID: meetingID, token: token)
                )
                
                let meetingDetail = meetingDetailEntity.toDomain(username: username)
                print(meetingDetail)
                
                return .success(meetingDetail)
            }.value
        } catch {
            if let apiError = error as? APIError {
                if apiError == .notFound {
                    return .notFound
                } else if apiError == .unauthorized {
                    return .userError
                }
            } else if let keyChainError = error as? KeyChainError {
                return .userError
            }
            return .networkError(error.localizedDescription)
        }
    }
}

extension DependencyValues {
    var meetingDetailService: MeetingDetailService {
        get { self[MeetingDetailService.self] }
        set { self[MeetingDetailService.self] = newValue }
    }
}
