//
//  MeetingAPI.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/11.
//

import Foundation

import Alamofire
import Moya

enum MeetingAPI {
    case meetingList
    case meetingDetail(meetingID: Int, token: String)
    case createMeeting
}


extension MeetingAPI: BaseAPI {
    
    static var apiType: APIType = .meeting
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .meetingList: return "list"
        case .meetingDetail: return "detail"
        case .createMeeting: return ""
        }
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        switch self {
        case .meetingDetail(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        default: return HeaderType.json.value
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        switch self {
        case .meetingDetail, .meetingList: return .get
        case .createMeeting: return .post
        }
    }
    
    // MARK: - Parameters
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        
        switch self {
        default: break
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
        default: return .requestPlain
        }
    }
}
