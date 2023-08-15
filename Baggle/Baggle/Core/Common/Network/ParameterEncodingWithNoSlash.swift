//
//  ParameterEncodingWithNoSlash.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/13.
//

import Foundation

import Alamofire
import Moya

struct JsonEncodingWithNoSlash: ParameterEncoding {
    func encode(
        _ urlRequest: URLRequestConvertible,
        with parameters: Parameters?
    ) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        var newString = ""
        if var urlString = urlRequest.url?.absoluteString,
           urlString.last == "/" {
            urlString.removeLast()
            newString = urlString
        }
        
        urlRequest.url = URL(string: newString)
        
        guard let parameters = parameters else { return urlRequest }
        
        guard JSONSerialization.isValidJSONObject(parameters) else {
            throw AFError.parameterEncodingFailed(reason:
                    .jsonEncodingFailed(error: APIError.jsonEncodingError)
            )
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters,
                                                  options: .withoutEscapingSlashes)
            
            if urlRequest.headers["Content-Type"] == nil {
                urlRequest.headers.update(.contentType("application/json"))
            }
            
            urlRequest.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}

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
