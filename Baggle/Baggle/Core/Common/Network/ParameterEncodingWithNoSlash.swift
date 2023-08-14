//
//  ParameterEncodingWithNoSlash.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/13.
//

import Foundation

import Alamofire
import Moya

struct ParameterEncodingWithNoSlash: ParameterEncoding {
    func encode(
        _ urlRequest: URLRequestConvertible,
        with parameters: Parameters?
    ) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        var newString = ""
        if var urlString = urlRequest.url?.absoluteString,
           let query = parameters?.queryParameters {
            urlString.removeLast()
            newString = urlString
            newString += "?"
            newString += query
        }
        
        urlRequest.url = URL(string: newString)
        
        return urlRequest
    }
}
