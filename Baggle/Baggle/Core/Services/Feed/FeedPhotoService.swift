//
//  FeedPhotoService.swift
//  Baggle
//
//  Created by youtak on 2023/08/16.
//

import Foundation

import ComposableArchitecture

typealias Token = String

struct FeedPhotoService {
    var upload: (FeedPhotoRequestModel) async -> FeedPhotoStatus
}

extension FeedPhotoService: DependencyKey {
    
    static let networkService = NetworkService<FeedAPI>()
    
    static var liveValue = Self { requestModel in
        do {
            let userToken = try KeychainManager.shared.readUserToken()
            let token = userToken.accessToken
            
            let feedPhotoEntity: FeedPhotoEntity = try await networkService
                .request(.uploadPhoto(requestModel: requestModel, token: token))
            
            guard let user = UserDefaultList.user else {
                return .userError
            }
            let feedUser = FeedUser(user: user)
            
            let feed = feedPhotoEntity.toDomain(feedUser: feedUser)
            
            return .success(feed)
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .badRequest:
                    return .invalidAuthorizationTime
                case .notFound:
                    return .notFound
                case .duplicatedUser:
                    return .alreadyUpload
                default:
                    return .networkError(apiError.localizedDescription)
                }
            } else if let keyChainError = error as? KeyChainError {
                return .userError
            }
            return .networkError(error.localizedDescription)
        }
    }
}

extension DependencyValues {
    var feedPhotoService: FeedPhotoService {
        get { self[FeedPhotoService.self] }
        set { self[FeedPhotoService.self] = newValue }
    }
}
