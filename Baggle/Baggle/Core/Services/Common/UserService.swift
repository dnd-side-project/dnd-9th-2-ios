//
//  UserService.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/10.
//

import Foundation

/// UserAPI에 포함되는 api를 다루는 service
protocol UserService {
    func postSignUp(requestModel: SignUpRequestModel, completion: @escaping (Result<SignUpEntity?, Error>) -> Void)
}

typealias DefaultUserService = BaseService<UserAPI>

extension DefaultUserService: UserService {
    func postSignUp(
        requestModel: SignUpRequestModel,
        completion: @escaping (Result<SignUpEntity?, Error>) -> Void
    ) {
        requestObject(.signUp(requestModel: requestModel), completion: completion)
    }
}
