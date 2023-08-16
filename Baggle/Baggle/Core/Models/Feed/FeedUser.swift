//
//  FeedUser.swift
//  Baggle
//
//  Created by youtak on 2023/08/16.
//

struct FeedUser {
    let id: Int
    let name: String
    let profileImageURL: String
}

extension FeedUser {    
    init(user: User) {
        self.init(
            id: user.id,
            name: user.name,
            profileImageURL: user.profileImageURL ?? ""
        )
    }
}
