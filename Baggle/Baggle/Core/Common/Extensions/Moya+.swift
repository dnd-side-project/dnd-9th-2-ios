//
//  Moya+.swift
//  Baggle
//
//  Created by youtak on 2023/08/17.
//

import Foundation

import Moya

extension MoyaProvider {
    func request(_ target: Target) async throws -> Data {
        return try await withCheckedThrowingContinuation({ continuation in
            self.request(target) { result in
                switch result {
                    
                case .success(let response):
                    dump(response)
                    continuation.resume(returning: response.data)
                    
                case .failure(let error):
                    print("❌ Request Error \(error)")
                    continuation.resume(throwing: APIError.providerRequest)
                }
            }
        })
    }
}
