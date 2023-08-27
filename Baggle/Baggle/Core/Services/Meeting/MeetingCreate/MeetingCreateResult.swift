//
//  MeetingCreateStatus.swift
//  Baggle
//
//  Created by youtak on 2023/08/16.
//

import Foundation

enum MeetingCreateResult: Equatable {
    case success(MeetingSuccessModel)
    case duplicatedMeeting // 모임 중복
    case userError // 로컬 유저 정보 불러오는데 에러
    case requestModelError // 요청 모델 생성시 에러 - 모델 값 중 옵셔널 값이 있음
    case networkError(String) // 네트워크 에러
}
