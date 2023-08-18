//
//  MeetingDetailService.swift
//  Baggle
//
//  Created by youtak on 2023/08/14.
//

import Foundation

import ComposableArchitecture

struct  MeetingDetailService {
    var fetchMeetingDetail: (_ meetingID: Int) async -> MeetingDetailStatus
}

extension MeetingDetailService: DependencyKey {
    
    static let networkService = NetworkService<MeetingAPI>()
    
    static var liveValue = Self { meetingID in
        do {
            guard let token = UserManager.shared.accessToken else {
                return .userError
            }
            
            let meetingDetailEntity: MeetingDetailEntity = try await networkService.request(
                .meetingDetail(meetingID: meetingID, token: token)
            )
            
            guard let username = UserDefaultList.user?.name else {
                return .userError
            }
            
            let meetingDetail = meetingDetailEntity.toDomain(username: username)
            
            return .success(meetingDetail)
        } catch {
            if let apiError = error as? APIError, apiError == .notFound {
                return .notFound
            } else if let keyChainError = error as? KeyChainError {
                return .userError
            } else {
                return .networkError(error.localizedDescription)
            }
        }
    }
}

extension DependencyValues {
    var meetingDetailService: MeetingDetailService {
        get { self[MeetingDetailService.self] }
        set { self[MeetingDetailService.self] = newValue }
    }
}
