//
//  EmergencyServiceStatus.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/16.
//

import Foundation

enum EmergencyServiceStatus: Equatable {
    case success
    case fail(APIError)
}
