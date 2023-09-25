//
//  HomeService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

import ComposableArchitecture

struct MeetingListService {
    var fetchMeetingList: (_ requestModel: HomeRequestModel) async -> MeetingListServiceResult
}

extension MeetingListService: DependencyKey {
    
    static let networkService = NetworkService<MeetingAPI>()

    static var liveValue = Self { requestModel in
        do {
            return try await Task.retrying {
                guard let accessToken = UserManager.shared.accessToken else {
                    return .userError
                }
                
                let data: HomeEntity = try await networkService.request(
                    .meetingList(requestModel: requestModel, token: accessToken)
                )
                
                return .success(data.toDomain())
            }.value
        } catch {
            print("❌ MeetingListService - error: \(error)")
            return .networkError(error.localizedDescription)
        }
    }
}

extension DependencyValues {
    var meetingListService: MeetingListService {
        get { self[MeetingListService.self] }
        set { self[MeetingListService.self] = newValue }
    }
}
