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
    case createMeeting(requestModel: MeetingCreateRequestModel, token: String)
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
        case .createMeeting(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        case .meetingList: return HeaderType.json.value
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
        case .meetingDetail(let meetingID, _):
            params["meetingId"] = meetingID
        case .createMeeting(let requestModel, _):
            params["title"] = requestModel.title
            params["place"] = requestModel.place
            params["meetingTime"] = requestModel.meetingTime.toIsoDate()
            if let memo = requestModel.memo {
                params["memo"] = memo
            }
        case .meetingList:
            break
        }
        
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .createMeeting: return JSONEncoding.default
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
        case .createMeeting:
            return .requestParameters(
                parameters: bodyParameters ?? [:],
                encoding: parameterEncoding
            )
        default:
            return .requestPlain
        }
    }
}
