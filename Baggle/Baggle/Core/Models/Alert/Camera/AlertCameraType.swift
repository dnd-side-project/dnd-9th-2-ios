//
//  AlertCameraType.swift
//  Baggle
//
//  Created by youtak on 2023/08/17.
//

import Foundation

enum AlertCameraType: Equatable {
    case cameraConfigureError
    case invalidAuthorizationTime
    case notFound
    case alreadyUpload
    case networkError(String) // 네트워크 에러
    case userError // 유저 에러
}

extension AlertCameraType {
    
    var title: String {
        switch self {
        case .cameraConfigureError: return "카메라 설정 에러"
        case .invalidAuthorizationTime: return "인증 시간 경과"
        case .notFound: return "모임 참가자가 없어요"
        case .alreadyUpload: return "피드 인증 완료"
        case .networkError: return "네트워크 에러"
        case .userError: return "유저 정보 에러"
        }
    }

    var description: String {
        switch self {
        case .cameraConfigureError: return "카메라를 초기화하는데 에러가 발생했어요. 카메라를 다시 실행해주세요."
        case .invalidAuthorizationTime: return "인증 시간이 지났어요."
        case .notFound: return "서버에서 유저 정보를 찾을 수 없어요."
        case .alreadyUpload: return "이미 인증을 완료했어요"
        case .networkError(let error): return "네트워크 에러 \(error)"
        case .userError: return "유저 정보를 불러오는데 에러가 발생했어요. 앱 종료 후 다시 시작해주세요."
        }
    }

    var buttonTitle: String {
        switch self {
        case .cameraConfigureError: return "돌아가기"
        case .invalidAuthorizationTime: return "돌아가기"
        case .notFound: return "확인"
        case .alreadyUpload: return "돌아가기"
        case .networkError: return "네트워크 에러"
        case .userError: return "앱 종료"
        }
    }
}
