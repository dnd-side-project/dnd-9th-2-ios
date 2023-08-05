//
//  UIImage+.swift
//  Baggle
//
//  Created by youtak on 2023/08/05.
//

import SwiftUI

extension UIImage {
    func cropToCenter() -> UIImage? {

        let shorterSide = min(self.size.width, self.size.height)
        let positionX = (self.size.width - shorterSide) / 2.0
        let positionY = (self.size.height - shorterSide) / 2.0

        let cropZone = CGRect(x: positionY, y: positionX, width: shorterSide, height: shorterSide)
        guard let cropImageRef = self.cgImage?.cropping(to: cropZone) else {
            return nil
        }

        let image = UIImage(
            cgImage: cropImageRef,
            scale: self.scale,
            orientation: self.imageOrientation
        )

        return image
    }
}
