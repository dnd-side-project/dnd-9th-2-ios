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
    
    static let baseService = BaseService<MeetingAPI>()
    
    static var liveValue = Self { meetingID in
        do {
            let userToken = try KeychainManager.shared.readUserToken()
            let token = userToken.accessToken
            
            let meetingDetailEntity: MeetingDetailEntity = try await baseService.request(
                .meetingDetail(meetingID: meetingID, token: token)
            )
            
            guard let userID = UserDefaultList.user?.id else {
                return .userError // fatalError?
            }
            
            let meetingDetail = meetingDetailEntity.toDomain(userID: userID)
            
            return .success(meetingDetail)
        } catch {
            if let apiError = error as? APIError {
                return .fail(apiError)
            } else {
                return .userError
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
