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
    case postJoinMeeting(meetingID: Int, token: String)
}

extension MemberAPI: BaseAPI {
    
    static var apiType: APIType = .member
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .fetchMeetingInfo: return ""
        case .postJoinMeeting: return ""
        }
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        switch self {
        case .fetchMeetingInfo(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        case .postJoinMeeting(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        switch self {
        case .fetchMeetingInfo: return .get
        case .postJoinMeeting: return .post
        }
    }
    
    // MARK: - Parameters
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        
        switch self {
        case .fetchMeetingInfo(let meetingID, _):
            params["meetingId"] = meetingID
        case .postJoinMeeting(let meetingID, _):
            params["meetingId"] = meetingID
        }
        
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchMeetingInfo:
            return ParameterEncodingWithNoSlash.init()
        case .postJoinMeeting:
            return JsonEncodingWithNoSlash.init()
        }
    }
    
    // MARK: - Task
    
    var task: Task {
        switch self {
        case .fetchMeetingInfo:
            return .requestParameters(parameters: bodyParameters ?? [:],
                                      encoding: parameterEncoding)
        case .postJoinMeeting:
            return .requestParameters(parameters: bodyParameters ?? [:],
                                      encoding: parameterEncoding)
        }
    }
}
