//
//  MeetingDetailService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

import ComposableArchitecture

struct MeetingDetailService {
    var fetchMeetingDetail: (_ meetingID: Int, _ userID: Int) async -> MeetingDetail?
}

extension MeetingDetailService: DependencyKey {
    static var liveValue = Self { meetingID, userID  in
        do {
            return try await MockUpMeetingDetailService()
                .fetchMeetingDetail(meetingID: meetingID, userID: userID)
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
    func fetchMeetingDetail(meetingID: Int, userID: Int) async throws -> MeetingDetail {
        return try await withCheckedThrowingContinuation({ continuation in
            if let meetingEntity = mockUpJSON() {
                continuation.resume(returning: meetingEntity.toDomain(userID: userID))
            }
        })
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
}
