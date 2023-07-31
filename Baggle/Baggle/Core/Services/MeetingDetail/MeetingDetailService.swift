//
//  MeetingDetailService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

import ComposableArchitecture

struct MeetingDetailService {
    var getMeetingDetail: (Int) async -> MeetingDetailModel?
}

extension MeetingDetailService: DependencyKey {
    static var liveValue = Self { id in
        do {
            return try await MockUpMeetingService().getMeetingDetail(id)
        } catch {
            return nil
        }
    }
}

extension DependencyValues {
    var meetingDetailService: MeetingDetailService {
        get { self[MeetingDetailService.self] }
        set { self[MeetingDetailService.self] = newValue }
    }
}

extension MockUpMeetingService {
    func getMeetingDetail(_ id: Int) async throws -> MeetingDetailModel {
        return try await withCheckedThrowingContinuation({ continuation in
            continuation.resume(returning: makeMeetingDetail(id))
        })
    }

    private func makeMeetingDetail(_ id: Int) -> MeetingDetailModel {
        let members = [
            MemberModel(userid: 1,
                        name: "안녕",
                        profile: "",
                        owner: true,
                        certefied: false),
            MemberModel(userid: 2,
                        name: "안녕222",
                        profile: "",
                        owner: true,
                        certefied: false)
        ]
        return MeetingDetailModel(
            id: id,
            name: "안녕하세요",
            place: "우리집",
            date: "2023년 08월 33일",
            time: "15:30",
            memo: "어서오세요",
            members: members,
            isConfirmed: false,
            emergencyButtonActive: false,
            emergencyButtonActiveTime: nil
        )
    }
}
