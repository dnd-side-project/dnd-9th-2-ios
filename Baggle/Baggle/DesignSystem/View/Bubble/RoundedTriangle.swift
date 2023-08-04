//
//  RoundedTriangle.swift
//  Baggle
//
//  Created by youtak on 2023/08/03.
//

import SwiftUI

struct RoundedTriangle: Shape {

    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: width, y: 0)
        let point3 = CGPoint(x: width / 2, y: height)

        path.move(to: point3)
        path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
        path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
        path.closeSubpath()

        return path
    }
}
