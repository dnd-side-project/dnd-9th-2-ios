//
//  MeetingEditService.swift
//  Baggle
//
//  Created by youtak on 2023/09/12.
//

import Foundation

import ComposableArchitecture

struct  MeetingEditService {
    var editMeeting: (
        _ beforeMeetingEditModel: MeetingEditModel,
        _ meetingEditModel: MeetingEditModel
    ) async -> MeetingEditResult
}

extension MeetingEditService: DependencyKey {
    
    static let networkService = NetworkService<MeetingAPI>()
    
    static var liveValue = Self { beforeModel, meetingEditModel in
        do {
            return try await Task.retrying {
                guard let token = UserManager.shared.accessToken,
                      let username = UserDefaultList.user?.name else {
                    return .userError
                }
                
                let meetingEditRequestModel = createRequestModel(beforeModel, meetingEditModel)
                
                print(meetingEditRequestModel)
                
                return .notFound
                
                let meetingEditEntity: MeetingEditEntity = try await networkService.request(
                    .editMeeting(requestModel: meetingEditRequestModel, token: token)
                )
                
                let meetingEditSuccessModel = meetingEditEntity.toDomain()
                
                return .success(meetingEditSuccessModel)
            }.value
        } catch {
            return .networkError(error.localizedDescription)
        }
    }
    
    static func createRequestModel(
        _ before: MeetingEditModel,
        _ after: MeetingEditModel
    ) -> MeetingEditRequestModel {
        MeetingEditRequestModel(
            meetingID: after.id,
            title: before.title == after.title ? nil : after.title,
            place: before.place == after.place ? nil : after.place,
            meetingTime: before.date == after.date ? nil : after.date,
            memo: (before.memo == after.memo) ? nil : after.memo
        )
    }
}

extension DependencyValues {
    var meetingEditService: MeetingEditService {
        get { self[MeetingEditService.self] }
        set { self[MeetingEditService.self] = newValue }
    }
}
