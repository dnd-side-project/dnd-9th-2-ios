//
//  EmergencyService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

import ComposableArchitecture
import Moya

struct EmergencyService {
    var emergency: (_ memberID: Int) async -> EmergencyServiceStatus
}

extension EmergencyService: DependencyKey {
    
    static let networkService = NetworkService<FeedAPI>()
    
    static var liveValue = Self { memberID in
        do {
            guard let accessToken = UserManager.shared.accessToken else {
                return .userError
            }
            let data: EmergencyEntity = try await networkService.request(
                .emergency(
                    memberID: memberID,
                    token: accessToken
                )
            )
            
            let certificationTime = data.certificationTime
            
            return .success(certificationTime)
        } catch {
            if let apiError = error as? APIError {
                if apiError == .badRequest {
                    return .invalidAuthorizationTime
                } else if apiError == .unauthorized {
                    return .unAuthorized
                } else if apiError == .notFound {
                    return .notFound
                }
            }
            return .networkError(error.localizedDescription)
        }
    }
}

extension DependencyValues {
    var emergencyService: EmergencyService {
        get { self[EmergencyService.self] }
        set { self[EmergencyService.self] = newValue }
    }
}
