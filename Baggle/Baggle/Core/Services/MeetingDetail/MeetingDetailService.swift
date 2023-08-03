//
//  MeetingDetailService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

import ComposableArchitecture

struct MeetingDetailService {
    var fetchMeetingDetail: (Int) async -> MeetingDetail?
}

extension MeetingDetailService: DependencyKey {
    static var liveValue = Self { id in
        do {
            return try await MockUpMeetingDetailService().fetchMeetingDetail(id)
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

struct MockUpMeetingDetailService {
    func fetchMeetingDetail(_ id: Int) async throws -> MeetingDetail {
        return try await withCheckedThrowingContinuation({ continuation in
            continuation.resume(returning: makeMockMeetingDetail(id))
        })
    }

    private func makeMockMeetingDetail(_ id: Int) -> MeetingDetail {
        let members = [
            Member(id: 1,
                   name: "안녕",
                   profileURL: "",
                   isOwner: true,
                   certified: false,
                   certImage: ""),
            Member(id: 2,
                   name: "안녕222",
                   profileURL: "",
                   isOwner: true,
                   certified: false,
                   certImage: "")
        ]
        return MeetingDetail(
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
