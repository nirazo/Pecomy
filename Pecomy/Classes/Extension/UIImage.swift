//
//  UIImage.swift
//  Pecomy
//
//  Created by Kenzo on 10/2/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

extension UIImage {
    func tint(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let drawRect = CGRectMake(0, 0, size.width, size.height)
        UIRectFill(drawRect)
        drawInRect(drawRect, blendMode: .DestinationIn, alpha: 1)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let tintIm = tintedImage {
            return tintIm
        }
        return self
    }
}
