//
//  MeetingDeleteResult.swift
//  Baggle
//
//  Created by youtak on 2023/09/07.
//

import Foundation

enum MeetingDeleteResult {
    case successDelegate // 방장 위임 성공
    case successLeave // 방장 아닌 사람이 나가기 성공
    case successDelete // 방장이 모임 폭파 성공

    case networkError
    case expiredToken
    case userError
}
