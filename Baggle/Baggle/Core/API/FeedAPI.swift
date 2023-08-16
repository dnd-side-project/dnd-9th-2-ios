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
    case upload
    case emergency(memberID: Int, token: String)
}


extension FeedAPI: BaseAPI {
    
    static var apiType: APIType = .feed
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .emergency: return ""
        default: return ""
        }
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        switch self {
        case .emergency(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        default: return HeaderType.json.value
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        switch self {
        case .emergency: return .get
        default: return .get
        }
    }
    
    // MARK: - Parameters
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        
        switch self {
        case .emergency(let memberID, _):
            params["memberId"] = memberID
            params["authorizationTime"] = Date().toIsoDate()
        default: break
        }
        
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .emergency:
            return ParameterEncodingWithNoSlash.init()
        default: return JSONEncoding.default
        }
    }
    
    // MARK: - Task
    
    var task: Task {
        switch self {
        case .emergency:
            return .requestParameters(parameters: bodyParameters ?? [:],
                                      encoding: parameterEncoding)
        default: return .requestPlain
        }
    }
}
