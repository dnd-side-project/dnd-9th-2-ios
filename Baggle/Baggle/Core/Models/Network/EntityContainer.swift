//
//  EntityContainer.swift
//  Baggle
//
//  Created by youtak on 2023/08/09.
//

import Foundation

struct EntityContainer<T>: Decodable where T: Decodable {
    let status: Int
    let message: String
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
}
