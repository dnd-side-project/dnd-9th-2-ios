//
//  FeedAPI.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/11.
//

import Foundation

import Alamofire
import Moya

enum FeedAPI {
    case emergency(memberID: Int, token: String)
    case uploadPhoto(requestModel: FeedPhotoRequestModel, token: String)
}


extension FeedAPI: BaseAPI {
    
    static var apiType: APIType = .feed
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .emergency: return ""
        case .uploadPhoto: return ""
        }
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        switch self {
        case .emergency(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        case .uploadPhoto(_, let token):
            return HeaderType.multipartWithBearer(token: token).value
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        switch self {
        case .emergency: return .get
        case .uploadPhoto: return .post
        }
    }
    
    // MARK: - Parameters
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        
        switch self {
        case .emergency(let memberID, _):
            params["memberId"] = memberID
            params["authorizationTime"] = Date().toIsoDate()
        case .uploadPhoto:
            break
        }
        
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .emergency: return ParameterEncodingWithNoSlash.init()
        case .uploadPhoto: return JSONEncoding.default
        }
    }
    
    // MARK: - Task
    
    var task: Task {
        switch self {
        case .emergency:
            return .requestParameters(
                parameters: bodyParameters ?? [:],
                encoding: parameterEncoding
            )
        case .uploadPhoto(let requestModel, _):
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(DateFormatter.baggleFormat)
            
            guard let memberInfoData = try? encoder.encode(requestModel.memberInfo) else {
                fatalError("유저 정보 인코딩 에러")
            }

            let memberInfoFormData = MultipartFormData(
                provider: .data(memberInfoData),
                name: "memberInfo",
                mimeType: "application/json"
            )

            let feedImageData = MultipartFormData(
                provider: .data(requestModel.feedImage),
                name: "feedImage",
                fileName: ".jpg",
                mimeType: "image/jpeg"
            )

            let multiPartData: [Moya.MultipartFormData] = [memberInfoFormData, feedImageData]
            
            return .uploadMultipart(multiPartData)
        }
    }
}
