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
            if let error = error as? KeyChainError {
                return .userError
            }
            return .error
        }
    }
}

extension DependencyValues {
    var feedPhotoService: FeedPhotoService {
        get { self[FeedPhotoService.self] }
        set { self[FeedPhotoService.self] = newValue }
    }
}
