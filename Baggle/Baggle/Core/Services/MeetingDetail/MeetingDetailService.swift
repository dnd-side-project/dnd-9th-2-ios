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
            if let memberEntity = mockUpJSON() {
                continuation.resume(returning: mockUpMemberList(memberEntity))
            }
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
                   // swiftlint:disable:next line_length
                   certImage: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Golde33443.jpg/280px-Golde33443.jpg"),
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
                   // swiftlint:disable:next line_length
                   certImage: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Pupplies_loving.jpg/1920px-Pupplies_loving.jpg"),
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
                // swiftlint:disable:next line_length
                Feed(id: 0, userId: 1, username: "수빈", userImageURL: "https://avatars.githubusercontent.com/u/81167570?v=4", feedImageURL: ""),
                // swiftlint:disable:next line_length
                Feed(id: 1, userId: 2, username: "유탁", userImageURL: "", feedImageURL: "https://avatars.githubusercontent.com/u/81167570?v=4")
            ]
        )
    }

    // MARK: - 로컬 Mock Up JSON

    private func mockUpJSON() -> MeetingDetailEntity? {

        let resource = "MockUpMeetingDetail"

        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            print("데이터 없음1")
            return nil
        }

        guard let jsonString = try? String(contentsOfFile: path) else {
            print("데이터 없음2")
            return nil
        }

        guard let data = jsonString.data(using: .utf8) else {
            print("데이터 없음3")
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let entityContainer = try? decoder.decode(
            EntityContainer<MeetingDetailEntity>.self,
            from: data
        ) else {
            print("디코딩 실패")
            return nil
        }

        print(entityContainer.status, entityContainer.message)

        return entityContainer.data
    }

    private func mockUpMemberList(_ meetingDetailEntity: MeetingDetailEntity) -> MeetingDetail {
        meetingDetailEntity.toDomain()
    }
}
