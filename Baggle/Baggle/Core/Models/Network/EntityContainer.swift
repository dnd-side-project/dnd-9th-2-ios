//
//  EntityContainer.swift
//  Baggle
//
//  Created by youtak on 2023/08/09.
//

import Foundation

struct EntityContainer<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T
}
