//
//  MeetingCreateService.swift
//  Baggle
//
//  Created by youtak on 2023/08/16.
//

import Foundation

import ComposableArchitecture

struct MeetingCreateService {
    var create: (_ meetingCreateModel: MeetingCreateModel) async -> MeetingCreateStatus
}

extension MeetingCreateService: DependencyKey {
    
    static let networkService = NetworkService<MeetingAPI>()
    
    static var liveValue = Self { meetingCreateModel in
        do {
            let userToken = try KeychainManager.shared.readUserToken()
            let token = userToken.accessToken
            
            guard let requestModel = MeetingCreateRequestModel(
                meetingCreateModel: meetingCreateModel
            ) else {
                return .requestModelError
            }
            
            let meetingCreateEntity: MeetingCreateEntity = try await networkService
                .request(
                    .createMeeting(
                        requestModel: requestModel,
                        token: token
                    )
                )

            let meetingSuccessModel = MeetingSuccessModel(
                id: meetingCreateEntity.meetingID,
                meetingCreateRequestModel: requestModel
            )
            
            return .success(meetingSuccessModel)
        } catch {
            if let error = error as? KeyChainError {
                return .userError
            }
            return .error
        }
    }
}

extension DependencyValues {
    var meetingCreateService: MeetingCreateService {
        get { self[MeetingCreateService.self] }
        set { self[MeetingCreateService.self] = newValue }
    }
}
