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
            
            let entity: MeetingCreateEntity = try await networkService
                .request(
                    .createMeeting(
                        requestModel: requestModel,
                        token: token
                    )
                )

            let model = MeetingSuccessModel(
                id: entity.meetingID,
                requestModel: requestModel
            )
            
            return .success(model)
        } catch {
            if let apiError = error as? APIError, apiError == .duplicatedMeeting {
                return .duplicatedMeeting
            } else if let keyChainError = error as? KeyChainError {
                return .userError
            }
            return .networkError(error.localizedDescription)
        }
    }
}

extension DependencyValues {
    var meetingCreateService: MeetingCreateService {
        get { self[MeetingCreateService.self] }
        set { self[MeetingCreateService.self] = newValue }
    }
}
