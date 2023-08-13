//
//  MemberAPI.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/11.
//

import Foundation

import Alamofire
import Moya

enum MemberAPI {
    case fetchMeetingInfo(meetingID: Int, token: String)
}

extension MemberAPI: BaseAPI {
    
    static var apiType: APIType = .member
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .fetchMeetingInfo: return ""
        }
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        switch self {
        case .fetchMeetingInfo(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        switch self {
        default: return .get
        }
    }
    
    // MARK: - Parameters
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        
        switch self {
        case .fetchMeetingInfo(let meetingID, _):
            params["meetingId"] = meetingID
        }
        
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        default: return JSONEncoding.default
        }
    }
    
    // MARK: - Task
    
    var task: Task {
        switch self {
        case .fetchMeetingInfo:
            return .requestParameters(parameters: bodyParameters ?? [:],
                                      encoding: ParameterEncodingWithNoSlash.init())
        }
    }
}
