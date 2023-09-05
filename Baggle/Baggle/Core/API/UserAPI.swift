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
    case signIn(requestModel: LoginRequestModel, token: String)
    case signUp(requestModel: SignUpRequestModel, token: String)
    case signOut(token: String)
    case reissue(token: String)
    case withdraw(token: String)
}

extension UserAPI: BaseAPI {
    
    static var apiType: APIType = .user
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .signIn: return "signin"
        case .signUp: return "signup"
        case .signOut: return "signout"
        case .reissue: return "reissue"
        case .withdraw: return "withdraw"
        }
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        switch self {
        case .signIn(_, let token):
            // 카카오 또는 애플 토큰
            return HeaderType.jsonWithAuthorization(token: token).value
        case .signUp(_, let token):
            // 카카오 또는 애플 토큰
            return HeaderType.multipart(token: token).value
        case .signOut(let token):
            return HeaderType.jsonWithBearer(token: token).value
        case .reissue(let token):
            // refreshToken
            return HeaderType.jsonWithAuthorization(token: token).value
        case .withdraw(let token):
            return HeaderType.jsonWithBearer(token: token).value
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp:
            return .post
        case .reissue:
            return .get
        case .withdraw, .signOut:
            return .patch
        }
    }
    
    // MARK: - Parameters
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        
        switch self {
        case .signIn(let requestModel, _):
            params["platform"] = requestModel.platform.rawValue
            params["fcmToken"] = requestModel.fcmToken
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
        case .signIn:
            return .requestParameters(parameters: bodyParameters ?? [:],
                                      encoding: parameterEncoding)
        case .signUp(let requestModel, _):
            var multiPartData: [Moya.MultipartFormData] = []
            let profileImageData = MultipartFormData(
                provider: .data(requestModel.profilImageUrl ?? Data()),
                name: "file",
                fileName: ".jpg",
                mimeType: "image/jpeg")
            multiPartData.append(profileImageData)
            
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
            
        case .reissue, .withdraw, .signOut:
            return .requestPlain
        }
    }
}
