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
    case delegateOwner(fromMemberID: Int, toMemberID: Int, token: String)
    case leaveMeeting(memberID: Int, token: String)
}

extension MemberAPI: BaseAPI {
    
    static var apiType: APIType = .member
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .fetchMeetingInfo: return ""
        case .postJoinMeeting: return "participation"
        case .delegateOwner: return "delegate"
        case .leaveMeeting: return "leave"
        }
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        switch self {
        case .fetchMeetingInfo(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        case .postJoinMeeting(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        case .delegateOwner(_, _, let token):
            return HeaderType.jsonWithBearer(token: token).value
        case .leaveMeeting(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        switch self {
        case .fetchMeetingInfo: return .get
        case .postJoinMeeting: return .post
        case .delegateOwner: return .patch
        case .leaveMeeting: return .patch
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
        case let .delegateOwner(fromMemberID, toMemberID, _):
            params["fromMemberId"] = fromMemberID
            params["toMemberId"] = toMemberID
        case .leaveMeeting(let memberID, _):
            params["memberId"] = memberID
        }
        
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchMeetingInfo, .delegateOwner, .leaveMeeting:
            return ParameterEncodingWithNoSlash.init()
        case .postJoinMeeting:
            return JSONEncoding.default
        }
    }
    
    // MARK: - Task
    
    var task: Task {
        switch self {
        case .fetchMeetingInfo, .postJoinMeeting, .delegateOwner, .leaveMeeting:
            return .requestParameters(
                parameters: bodyParameters ?? [:],
                encoding: parameterEncoding
            )
        }
    }
}
