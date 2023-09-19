//
//  ReportAPI.swift
//  Baggle
//
//  Created by 양수빈 on 2023/09/18.
//

import Foundation

import Alamofire
import Moya

enum ReportAPI {
    case feedReport(requestModel: FeedReportRequestModel, token: String)
}

extension ReportAPI: BaseAPI {
    
    static var apiType: APIType = .report
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .feedReport: return ""
        }
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        switch self {
        case .feedReport(_, let token):
            return HeaderType.jsonWithBearer(token: token).value
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        switch self {
        case .feedReport: return .post
        }
    }
    
    // MARK: - Parameters
    
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        
        switch self {
        case .feedReport(let requestModel, _):
            params["participationId"] = requestModel.participationID
            params["feedId"] = requestModel.feedID
            params["reportType"] = requestModel.reportType?.rawValue
        }
        
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .feedReport: return JSONEncoding.default
        }
    }
    
    // MARK: - Task
    
    var task: Moya.Task {
        switch self {
        case .feedReport:
            return .requestParameters(
                parameters: bodyParameters ?? [:],
                encoding: parameterEncoding
            )
        }
    }
}
