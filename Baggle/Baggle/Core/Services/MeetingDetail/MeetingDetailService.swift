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
                   isMeetingAuthority: true,
                   isButtonAuthority: true,
                   certified: true,
                   certImage: ""),
            Member(id: 2,
                   name: "안녕222",
                   profileURL: "",
                   isMeetingAuthority: false,
                   isButtonAuthority: true,
                   certified: false,
                   certImage: ""),
            Member(id: 3,
                   name: "안녕하세용가리",
                   profileURL: "",
                   isMeetingAuthority: true,
                   isButtonAuthority: false,
                   certified: true,
                   certImage: ""),
            Member(id: 4,
                   name: "감자탕",
                   profileURL: "",
                   isMeetingAuthority: false,
                   isButtonAuthority: false,
                   certified: false,
                   certImage: "")
        ]
        return MeetingDetail(
            id: id,
            name: "안녕하세요",
            place: "우리집",
            date: "2023년 08월 33일",
            time: "15:30",
            memo: nil,// "어서오세요어서오세요어서오세요 어서오세요어서오세요 어서오세요 어서오세요",
            members: members,
            status: .confirmed,
            emergencyButtonActive: false,
            emergencyButtonActiveTime: nil,
            feeds: [
                Feed(id: 0, userId: 1, username: "수빈", userImageURL: "", feedImageURL: ""),
                Feed(id: 1, userId: 2, username: "유탁", userImageURL: "", feedImageURL: "")
            ]
        )
    }
}
