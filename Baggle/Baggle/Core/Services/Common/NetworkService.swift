//
//  BaseService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/10.
//

import Combine
import Foundation

import Alamofire
import Moya

class NetworkService<Target: TargetType> {
    typealias API = Target
    
    private lazy var provider = self.defaultProvider
    
    private lazy var defaultProvider: MoyaProvider<API> = {
        let provider = MoyaProvider<API>(
            endpointClosure: endpointclosure,
            session: DefaultAlamofireManager.shared)
        return provider
    }()
    
    private let endpointclosure = { (target: API) -> Endpoint in
        var urlString = target.baseURL.appendingPathComponent(target.path).absoluteString
        if urlString.hasSuffix("/") {
            urlString = String(urlString.dropLast())
        }
        
        var endpoint: Endpoint = Endpoint(
            url: urlString,
            sampleResponseClosure: {.networkResponse(200, target.sampleData)},
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers)
        return endpoint
    }
    
    public init() {}
}

extension NetworkService {
    var `default`: NetworkService {
        self.provider = self.defaultProvider
        return self
    }
    
    func request<T: Decodable>(_ target: API) async throws -> T {
        let data = try await provider.request(target)
        print("✅ raw data: \(String(data: data, encoding: .utf8))")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.baggleFormat)
        guard let body = try? decoder.decode(EntityContainer<T>.self, from: data) else {
            throw APIError.decoding
        }
        
        let statusCode = body.status
        let message = body.message
        
        switch statusCode {
        case 200, 201:
            guard let data = body.data else {
                throw APIError.unwrapping
            }
            print("✅ data: \(data)")
            return data
        case 400..<500:
            throw handleError400(statusCode: statusCode, message: message)
        case 500:
            throw APIError.server
        default:
            throw APIError.network
        }
    }
    
    func requestWithNoResult(_ target: API) async throws {
        let data = try await provider.request(target)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.baggleFormat)
        guard let body = try? decoder.decode(EntityContainer<JSONNull>.self, from: data) else {
            throw APIError.decoding
        }
        
        let statusCode = body.status
        let message = body.message

        switch statusCode {
        case 200, 201:
            return
        case 400..<500:
            throw handleError400(statusCode: statusCode, message: message)
        case 500:
            throw APIError.server
        default:
            throw APIError.network
        }
    }

    private func handleError400(statusCode: Int, message: String) -> APIError {
        switch statusCode {
        case 400:
            return APIError.badRequest
        case 401:
            return APIError.unauthorized
        case 403:
            if message == "모임은 하루에 2개까지만 생성 가능합니다." {
                return APIError.duplicatedMeeting
            } else {
                return APIError.forbidden
            }
        case 404:
            return APIError.notFound
        case 409:
            if message == "이미 존재하는 닉네임입니다." {
                return APIError.duplicatedNickname
            } else if message == "이미 존재하는 참가자입니다." {
                return APIError.duplicatedJoinMeeting
            } else {
                return APIError.duplicatedUser
            }
        default:
            return APIError.network
        }
    }
}
