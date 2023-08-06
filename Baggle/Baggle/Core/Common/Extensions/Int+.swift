//
//  Int+.swift
//  Baggle
//
//  Created by youtak on 2023/08/05.
//

extension Int {

    var minutes: Int {
        return self / 60
    }

    var seconds: Int {
        return self % 60
    }

    var tenDigit: Int {
        return (self % 60) / 10
    }

    var oneDigit: Int {
        return (self % 60) % 10
    }

    var doubleDigit: String {
        if self >= 100 {
            return String(self % 100)
        } else if self >= 10 {
            return String(self)
        } else {
            return "0" + String(self)
        }
    }
}
