//
//  HomeService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

import ComposableArchitecture

struct HomeService {
    var fetchMeetingList: (MeetingStatus) async -> [Meeting]?
}

extension HomeService: DependencyKey {

    static var liveValue = Self { type in
        do {
            return try await MockUpMeetingService().fetchMeetingList(type)
        } catch {
            return nil
        }
    }
}

extension DependencyValues {
    var meetingService: HomeService {
        get { self[HomeService.self] }
        set { self[HomeService.self] = newValue }
    }
}

struct MockUpMeetingService {
    func fetchMeetingList(_ type: MeetingStatus) async throws -> [Meeting] {
        return try await withCheckedThrowingContinuation({ continuation in
            continuation.resume(returning: makeMockMeetingList(type))
        })
    }

    private func makeMockMeetingList(_ type: MeetingStatus) -> [Meeting] {
        let ongoing = [
            Meeting(
                id: 1,
                name: "진행 중인 모임",
                place: "우리집",
                date: "2023년 04월 22일",
                time: "15:30",
                profileImages: [
                    "https://avatars.githubusercontent.com/u/71167956?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/81167570?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/71776532?s=64&v=4"
                ],
                isConfirmed: false),
            Meeting(
                id: 2,
                name: "진행 중인 모임2",
                place: "남의 집",
                date: "2023년 08년 23일",
                time: "15:30",
                profileImages: [
                    "https://avatars.githubusercontent.com/u/81167570?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/71776532?s=64&v=4"
                ],
                isConfirmed: false)
        ]

        let complete = [
            Meeting(
                id: 1,
                name: "진행 중인 모임",
                place: "우리집",
                date: "2023년 04월 22일",
                time: "15:30",
                profileImages: [
                    "https://avatars.githubusercontent.com/u/71167956?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/81167570?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/71776532?s=64&v=4"
                ],
                isConfirmed: false)
        ]
        return type == .ongoing ? ongoing : complete
    }
}
