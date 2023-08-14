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

class BaseService<Target: TargetType> {
    typealias API = Target
    
    private lazy var provider = self.defaultProvider
    
    private lazy var defaultProvider: MoyaProvider<API> = {
        let provider = MoyaProvider<API>(
            endpointClosure: endpointclosure,
            session: DefaultAlamofireManager.shared)
        return provider
    }()
    
    private let endpointclosure = { (target: API) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        var endpoint: Endpoint = Endpoint(
            url: url,
            sampleResponseClosure: {.networkResponse(200, target.sampleData)},
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers)
        return endpoint
    }
    
    public init() {}
}

extension BaseService {
    var `default`: BaseService {
        self.provider = self.defaultProvider
        return self
    }
    
    func request<T: Decodable>(_ target: API) async throws -> T {
        return try await withCheckedThrowingContinuation({ continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        print("response: \(response)")
                        let decoder = JSONDecoder()
                        let body = try decoder.decode(EntityContainer<T>.self, from: response.data)
                        switch body.status {
                        case 200:
                            if let data = body.data {
                                print("✅ 200 data -", data)
                                continuation.resume(returning: data)
                            } else {
                                continuation.resume(throwing: APIError.decoding)
                            }
                        case 201:
                            if let data = body.data {
                                print("✅ 201 data -", data)
                                continuation.resume(returning: data)
                            } else {
                                continuation.resume(throwing: APIError.decoding)
                            }
                        case 400:
                            continuation.resume(throwing: APIError.badRequest)
                        case 401:
                            continuation.resume(throwing: APIError.unauthorized)
                        case 404:
                            continuation.resume(throwing: APIError.notFound)
                        case 409:
                            if body.message == "이미 존재하는 닉네임입니다." {
                                continuation.resume(throwing: APIError.duplicatedNickname)
                            } else if body.message == "이미 존재하는 참가자입니다." {
                                continuation.resume(throwing: APIError.duplicatedJoinMeeting)
                            } else {
                                continuation.resume(throwing: APIError.duplicatedUser)
                            }
                        default:
                            continuation.resume(throwing: APIError.network)
                        }
                    } catch let error {
                        print("❌ error - \(error)")
                        continuation.resume(throwing: APIError.decoding)
                    }
                case .failure(let error):
                    print("❌ error - \(error)")
                    continuation.resume(throwing: APIError.badRequest)
                }
            }
        })
    }
    
    func requestWithNoResult(_ target: API) async throws -> Int {
        return try await withCheckedThrowingContinuation({ continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        print("response: \(response)")
                        let decoder = JSONDecoder()
                        let body = try decoder.decode(EntityContainer<Bool>.self,
                                                      from: response.data)
                        switch body.status {
                        case 200, 201:
                            continuation.resume(returning: body.status)
                        case 400:
                            continuation.resume(throwing: APIError.badRequest)
                        case 401:
                            continuation.resume(throwing: APIError.unauthorized)
                        case 404:
                            continuation.resume(throwing: APIError.notFound)
                        case 409:
                            continuation.resume(throwing: APIError.duplicatedUser)
                        default:
                            continuation.resume(throwing: APIError.network)
                        }
                    } catch let error {
                        print("❌ error - \(error)")
                        continuation.resume(throwing: APIError.decoding)
                    }
                case .failure(let error):
                    print("❌ error - \(error)")
                    continuation.resume(throwing: APIError.badRequest)
                }
            }
        })
    }
}
