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
    case meetingList(period: MeetingPeriodStatus, page: Int, size: Int, token: String)
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
        case .meetingList(_, _, _, let token):
            return HeaderType.jsonWithBearer(token: token).value
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
        case .meetingList(let period, let page, let size, _):
            params["period"] = period.rawValue
            params["page"] = page
            params["size"] = size
        case .meetingDetail(let meetingID, _):
            params["meetingId"] = meetingID
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
        case .meetingDetail:
            return .requestParameters(
                parameters: bodyParameters ?? [:],
                encoding: ParameterEncodingWithNoSlash()
            )
        default:
            return .requestPlain
        }
    }
}
