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

struct MockUpMeetingService {

    func fetchMeetingList(_ type: MeetingStatus) async throws -> [Meeting] {
        return try await withCheckedThrowingContinuation({ continuation in
            continuation.resume(returning: makeMockMeetingList(type))
        })
    }

    private func makeMockMeetingList(_ type: MeetingStatus) -> [Meeting] {
        let progress = [
            Meeting(
                id: 9,
                name: "id가 9입니다.",
                place: "우리집",
                date: "2023년 04월 22일",
                time: "15:30",
                dDay: 0,
                profileImages: [
                    "https://avatars.githubusercontent.com/u/71167956?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/81167570?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/71776532?s=64&v=4"
                ],
                status: .progress
            ),
            Meeting(
                id: 10,
                name: "id가 10입니다.",
                place: "남의 집",
                date: "2023년 08년 23일",
                time: "15:30",
                dDay: 30,
                profileImages: [
                    "https://avatars.githubusercontent.com/u/81167570?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/71776532?s=64&v=4"
                ],
                status: .ready
            ),
            Meeting(
                id: 11,
                name: "id가 11입니다.",
                place: "우리집",
                date: "2023년 04월 22일",
                time: "15:30",
                dDay: 0,
                profileImages: [
                    "https://avatars.githubusercontent.com/u/71167956?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/81167570?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/71776532?s=64&v=4"
                ],
                status: .progress
            ),
            Meeting(
                id: 4,
                name: "id가 4입니다.",
                place: "남의 집",
                date: "2023년 08년 23일",
                time: "15:30",
                dDay: 30,
                profileImages: [
                ],
                status: .ready
            ),
            Meeting(
                id: -999,
                name: "id 전달 에러 케이스.",
                place: "남의 집",
                date: "2023년 08년 23일",
                time: "15:30",
                dDay: 30,
                profileImages: [
                ],
                status: .ready
            )
        ]

        let complete = [
            Meeting(
                id: Int.random(in: 1...100),
                name: "지난 모임",
                place: "우리집",
                date: "2023년 04월 22일",
                time: "15:30",
                dDay: -10,
                profileImages: [
                    "https://avatars.githubusercontent.com/u/71167956?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/81167570?s=64&v=4",
                    "https://avatars.githubusercontent.com/u/71776532?s=64&v=4"
                ],
                status: .completed
            )
        ]
        return type == .progress ? progress : complete
    }
}
