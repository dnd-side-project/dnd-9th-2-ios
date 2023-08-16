//
//  MeetingDetailService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/31.
//

import Foundation

import ComposableArchitecture

#if DEBUG

struct MockUpMeetingDetailService {
    var fetchMeetingDetail: (_ meetingID: Int, _ userID: Int) async -> MeetingDetail?
}

extension MockUpMeetingDetailService: DependencyKey {
    static var liveValue = Self { meetingID, userID  in
        do {
            return try await MockUpMeetingAPI()
                .meetingDetail(status: .confirmedEmergency)
//                .fetchMeetingDetail(meetingID: meetingID, userID: userID)
        } catch {
            return nil
        }
    }
}

extension DependencyValues {
    var mockUpMeetingDetailService: MockUpMeetingDetailService {
        get { self[MockUpMeetingDetailService.self] }
        set { self[MockUpMeetingDetailService.self] = newValue }
    }
}

struct MockUpMeetingAPI {

    func fetchMeetingDetail(meetingID: Int) async throws -> MeetingDetail {
        return try await withCheckedThrowingContinuation({ continuation in
            if let meetingEntity = mockUpJSON(),
               let username = UserDefaultList.user?.name {
                continuation.resume(returning: meetingEntity.toDomain(username: username))
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


// MARK: - Mock Up Data


extension MockUpMeetingAPI {
    
    enum MockUpStatus {
        case completed
        case ready
        case confirmed
        case confirmedEmergency
    }
    
    func meetingDetail(status: MockUpStatus) async throws -> MeetingDetail {
        return try await withCheckedThrowingContinuation({ continuation in
            switch status {
            case .completed:
                continuation.resume(returning: meetingDetailCompleted())
            case .ready:
                continuation.resume(returning: meetingDetailReady())
            case .confirmed:
                continuation.resume(returning: meetingDetailConfirm())
            case .confirmedEmergency:
                continuation.resume(returning: meetingDetailConfirmEmergency())
            }
        })
    }
    
    private func meetingDetailCompleted() -> MeetingDetail {
        MeetingDetail(
            id: 0,
            name: "완료된 모임",
            place: "샌프란시스코",
            date: "2022년 7월 31일",
            time: "19:30",
            memo: "슈퍼두퍼 먹자",
            members: [
                Member(
                    id: 0,
                    name: "테스트 유저1",
                    profileURL: "https://avatars.githubusercontent.com/u/71776532?v=4",
                    isMeetingAuthority: true,
                    isButtonAuthority: true,
                    certified: true,
                    certImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230327_112%2F16799270480919mNeo_JPEG%2F1679927034445.jpg"
                    // swiftlint:disable:previous line_length
                ),
                Member(
                    id: 1,
                    name: "유저2",
                    profileURL: "https://avatars.githubusercontent.com/u/81167570?v=4",
                    isMeetingAuthority: false,
                    isButtonAuthority: false,
                    certified: true,
                    certImage: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230712_205%2F1689152621857ctqiJ_JPEG%2F%25C8%25A3%25C4%25BF%25BC%25BE%25C5%25CD%25BB%25E7%25C1%25F8_1.jpg"
                    // swiftlint:disable:previous line_length
                )
            ],
            memberId: 1,
            status: .completed,
            isEmergencyAuthority: true,
            emergencyButtonActive: false,
            emergencyButtonActiveTime: Date(timeIntervalSince1970: 1659261600),
            isCertified: true,
            feeds: [
                Feed(
                    id: 0,
                    userId: 0,
                    username: "테스트 유저1",
                    userImageURL: "https://avatars.githubusercontent.com/u/71776532?v=4",
                    feedImageURL: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230327_112%2F16799270480919mNeo_JPEG%2F1679927034445.jpg"
                    // swiftlint:disable:previous line_length
                ),
                Feed(
                    id: 1,
                    userId: 1,
                    username: "유저2",
                    userImageURL: "https://avatars.githubusercontent.com/u/81167570?v=4",
                    feedImageURL: "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20230712_205%2F1689152621857ctqiJ_JPEG%2F%25C8%25A3%25C4%25BF%25BC%25BE%25C5%25CD%25BB%25E7%25C1%25F8_1.jpg"
                    // swiftlint:disable:previous line_length
                )
            ]
        )
    }

    private func meetingDetailReady() -> MeetingDetail {
        MeetingDetail(
            id: 0,
            name: "연말 모임",
            place: "샌프란시스코",
            date: "2024년 12월 31일",
            time: "19:30",
            memo: "24년 안녕~",
            members: [
                Member(
                    id: 0,
                    name: "테스트 유저1",
                    profileURL: "https://avatars.githubusercontent.com/u/71776532?v=4",
                    isMeetingAuthority: true,
                    isButtonAuthority: false,
                    certified: false,
                    certImage: ""
                ),
                Member(
                    id: 1,
                    name: "유저2",
                    profileURL: "https://avatars.githubusercontent.com/u/81167570?v=4",
                    isMeetingAuthority: false,
                    isButtonAuthority: false,
                    certified: false,
                    certImage: ""
                )
            ],
            memberId: 1,
            status: .ready,
            isEmergencyAuthority: false,
            emergencyButtonActive: false,
            emergencyButtonActiveTime: nil,
            isCertified: false,
            feeds: []
        )
    }

    private func meetingDetailConfirm() -> MeetingDetail {
        MeetingDetail(
            id: 0,
            name: "DND 6주차 회의",
            place: "종각역",
            date: "2023년 08월 13일",
            time: "12:00",
            memo: "점뭐먹",
            members: [
                Member(
                    id: 0,
                    name: "테스트 유저1",
                    profileURL: "https://avatars.githubusercontent.com/u/71776532?v=4",
                    isMeetingAuthority: false,
                    isButtonAuthority: true,
                    certified: false,
                    certImage: ""
                ),
                Member(
                    id: 1,
                    name: "유저2",
                    profileURL: "https://avatars.githubusercontent.com/u/81167570?v=4",
                    isMeetingAuthority: true,
                    isButtonAuthority: false,
                    certified: false,
                    certImage: ""
                )
            ],
            memberId: 1,
            status: .confirmed,
            isEmergencyAuthority: true,
            emergencyButtonActive: false,
            emergencyButtonActiveTime: nil,
            isCertified: false,
            feeds: []
        )
    }
    
    private func meetingDetailConfirmEmergency() -> MeetingDetail {
        MeetingDetail(
            id: 0,
            name: "DND 최종 발표",
            place: "영등포",
            date: "2023년 08월 11일",
            time: "13:45",
            memo: "2조 짱",
            members: [
                Member(
                    id: 0,
                    name: "테스트 유저1",
                    profileURL: "https://avatars.githubusercontent.com/u/71776532?v=4",
                    isMeetingAuthority: true,
                    isButtonAuthority: false,
                    certified: false,
                    certImage: ""
                ),
                Member(
                    id: 1,
                    name: "유저2",
                    profileURL: "https://avatars.githubusercontent.com/u/81167570?v=4",
                    isMeetingAuthority: false,
                    isButtonAuthority: true,
                    certified: false,
                    certImage: ""
                )
            ],
            memberId: 1,
            status: .confirmed,
            isEmergencyAuthority: true,
            emergencyButtonActive: true,
            emergencyButtonActiveTime: Date.createDate(2023, 8, 11, 13, 30),
            isCertified: false,
            feeds: []
        )
    }
}
#endif
