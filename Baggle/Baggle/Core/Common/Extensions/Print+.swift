//
//  Print+.swift
//  Baggle
//
//  Created by youtak on 2023/08/15.
//

import Foundation

public func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}
