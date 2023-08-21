//
//  AlertType.swift
//  Baggle
//
//  Created by 양수빈 on 2023/08/22.
//

import Foundation

protocol AlertType {
    var buttonType: AlertButtonType { get }
    var title: String { get }
    var description: String { get }
    var buttonTitle: String { get }
}
