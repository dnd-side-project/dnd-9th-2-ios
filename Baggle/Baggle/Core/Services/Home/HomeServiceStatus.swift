//
//  HomeServiceStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/17.
//

import Foundation

enum HomeServiceStatus {
    case success(Home)
    case fail(APIError)
}
