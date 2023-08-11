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
                        let decoder = JSONDecoder()
                        let body = try decoder.decode(EntityContainer<T>.self, from: response.data)
                        continuation.resume(returning: body.data)
                    } catch let error {
                        // error 분기처리 필요
                        print("❌ error - \(error)")
                        continuation.resume(throwing: NetworkError.decodingError)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
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
