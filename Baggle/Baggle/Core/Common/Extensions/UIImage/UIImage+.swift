//
//  UIImage+.swift
//  Baggle
//
//  Created by youtak on 2023/08/05.
//

import SwiftUI

extension UIImage {

    // 이미지 정중앙 크롭
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

    // 이미지 좌우 반전
    func flippedHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.translateBy(x: self.size.width, y: 0.0)
        context.scaleBy(x: -1.0, y: 1.0)

        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return flippedImage
    }
}


// MARK: - 이미지 다운 스케일링 & 압축
extension UIImage {
    func scaleTo(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    func compress(width: CGFloat) -> UIImage {
        let resizedImage = scaleTo(newWidth: width)
        return resizedImage
    }
    
    func compress(imageSize: ImageSizeType) -> UIImage {
        return compress(width: imageSize.size)
    }
}
