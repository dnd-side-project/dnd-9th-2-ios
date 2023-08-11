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
    case signUp(requestModel: SignUpRequestModel)
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
        case .signUp:
            return HeaderType.multipart(token: "").value // 카카오 또는 애플 토큰
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
        case .signUp(let requestModel):
            params["profileImageUrl"] = requestModel.profilImageUrl
            params["nickname"] = requestModel.nickname
            params["platform"] = requestModel.platform
            params["fcmToken"] = requestModel.platform
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
        case .signIn, .signUp:
            return .requestParameters(
                parameters: bodyParameters ?? [:],
                encoding: parameterEncoding)
        case .reissue:
            return .requestPlain
        }
    }
}
