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
                        print("✅ response -", response)
                        switch body.status {
                        case 200:
                            if let data = body.data {
                                print("✅ 200 data -", data)
                                continuation.resume(returning: data)
                            }
                        case 201:
                            if let data = body.data {
                                print("✅ 201 data -", data)
                                continuation.resume(returning: data)
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
                            } else if body.message == "이미 참여 중인 약속입니다." {
                                // TODO: - 메세지 확인 후 수정
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
    
    func requestObject<T: Decodable>(
        _ target: API,
        completion: @escaping(Result<T?, Error>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(EntityContainer<T>.self, from: value.data)
                    completion(.success(body.data))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ fail - \(error)")
                completion(.failure(error))
            }
        }
    }
}
