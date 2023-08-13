//
//  BaseAPI.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/10.
//

import Foundation

import Moya

enum APIType {
    case user
    case meeting
    case member
    case feed
}

protocol BaseAPI: TargetType {
    static var apiType: APIType { get set }
}

extension BaseAPI {
    var baseURL: URL {
        var base = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
        
        switch Self.apiType {
        case .user:
            base += "/api/user"
        case .meeting:
            base += "/api/meeting"
        case .member:
            base += "/api/member"
        case .feed:
            base += "/api/feed"
        }
        
        guard let url = URL(string: base) else {
            fatalError("baseURL could not be configued")
        }
        
        return url
    }
    
    var headers: [String: String]? {
        return HeaderType.json.value
    }
}

enum HeaderType {
    case json
    case jsonWithAuthorization(token: String)
    case jsonWithBearer(token: String)
    case multipart(token: String)
    
    var value: [String: String] {
        switch self {
        case .json:
            return ["Content-Type": "application/json"]
            
        case .jsonWithAuthorization(let token):
            return ["Content-Type": "application/json",
                    "Authorization": token]
            
        case .jsonWithBearer(let token):
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(token)"]
            
        case .multipart(let token):
            return ["Content-Type": "multipart/form-data",
                    "Authorization": token]
        }
    }
}
