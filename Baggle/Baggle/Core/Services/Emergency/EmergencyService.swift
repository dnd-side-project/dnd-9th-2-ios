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
    var emergency: (_ meetingID: Int) async -> Bool
}

extension EmergencyService: DependencyKey {
    
    static let networkService = NetworkService<FeedAPI>()
    
    static var liveValue = Self { meetingID in
        do {
            let accessToken = try KeychainManager.shared.readUserToken().accessToken
            let data: EmergencyEntity = try await networkService.request(
                .emergency(
                    meetingID: meetingID,
                    token: accessToken
                )
            )
            return true
        } catch let error {
            print("EmergencyService error - \(error)")
            return false
        }
    }
}

extension DependencyValues {
    var emergencyService: EmergencyService {
        get { self[EmergencyService.self] }
        set { self[EmergencyService.self] = newValue }
    }
}
