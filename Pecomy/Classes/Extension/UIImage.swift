//
//  UIImage.swift
//  Pecomy
//
//  Created by Kenzo on 10/2/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

extension UIImage {
    func tint(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let tintIm = tintedImage {
            return tintIm
        }
        return self
    }
}
