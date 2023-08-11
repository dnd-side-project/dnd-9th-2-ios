//
//  UserAPI.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/10.
//

import Foundation

import Alamofire
import Moya

enum UserAPI {
    case signIn
    case signUp(requestModel: SignUpRequestModel, token: String)
    case reissue
}

extension UserAPI: BaseAPI {
    
    static var apiType: APIType = .user
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .signIn: return "signin"
        case .signUp: return "signup"
        case .reissue: return "reissue"
        }
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        switch self {
        case .signIn:
            return HeaderType.jsonWithAuthorization(token: "").value // 카카오 또는 애플 토큰
        case .signUp(_, let token):
            return HeaderType.multipart(token: token).value // 카카오 또는 애플 토큰
        case .reissue:
            return HeaderType.jsonWithAuthorization(token: "").value // refreshToken
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp:
            return .post
        case .reissue:
            return .get
        }
    }
    
    // MARK: - Parameters
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        
        switch self {
        default:
            break
        }
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        default: return JSONEncoding.default
        }
    }
    
    // MARK: - Task
    
    var task: Moya.Task {
        switch self {
        case .signUp(let requestModel, _):
            var multiPartData: [Moya.MultipartFormData] = []
            let imageData = MultipartFormData(
                provider: .data(requestModel.profilImageUrl ?? Data()),
                name: "file",
                fileName: ".jpg",
                mimeType: "image/jpeg")
            multiPartData.append(imageData)
            
            let parameters: [String: String] = [
                "nickname": requestModel.nickname,
                "platform": requestModel.platform.rawValue,
                "fcmToken": requestModel.fcmToken
            ]
            
            for (key, value) in parameters {
                multiPartData.append(MultipartFormData(
                    provider: .data(value.data(using: .utf8) ?? Data()),
                    name: key))
            }
            
            return .uploadMultipart(multiPartData)
            
        case .signIn, .reissue:
            return .requestPlain
        }
    }
}
