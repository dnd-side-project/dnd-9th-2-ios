//
//  HomeService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

import ComposableArchitecture

struct MeetingListService {
    var fetchMeetingList: (_ requestModel: HomeRequestModel) async -> HomeServiceStatus
}

extension MeetingListService: DependencyKey {
    
    static let networkService = NetworkService<MeetingAPI>()

    static var liveValue = Self { requestModel in
        do {
            guard let accessToken = UserManager.shared.accessToken else {
                return .fail(.network)
            }
            let data: HomeEntity = try await networkService.request(
                .meetingList(requestModel: requestModel, token: accessToken)
            )
            return .success(data.toDomain())
        } catch let error {
            print("❌ MeetingListService - error: \(error)")
            return .fail(.network)
        }
    }
}

extension DependencyValues {
    var meetingService: MeetingListService {
        get { self[MeetingListService.self] }
        set { self[MeetingListService.self] = newValue }
    }
}

