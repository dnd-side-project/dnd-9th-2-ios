//
//  DefaultAlamofireManager.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/10.
//

import Foundation

import Alamofire

class DefaultAlamofireManager: Alamofire.Session {
    static let shared: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
