//
//  UIImage+Extension.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/8.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit
import XCGLogger

// MARK: - Factory
extension UIImage {
    class func image(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)

        color.setFill()
        let context = UIGraphicsGetCurrentContext()
        CGContextFillRect(context, CGRect(origin: CGPointZero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let result = image {
            return result
        } else {
            return UIImage()
        }
    }

    class func strokeImage(color: UIColor, size: CGSize, borderColor: UIColor, borderWidth: CGFloat = 1, align: Bool = true) -> UIImage {
        // 4字节对齐
        var alignedSize = size
        if align {
            alignedSize.width = CGFloat(Int(((size.width + 3) / 4)) * 4)
        }
        UIGraphicsBeginImageContextWithOptions(alignedSize, true, 0)

        XCGLogger.info("\(size) -> \(alignedSize)")

        let scale = UIScreen.mainScreen().scale
        let lineWidth = CGFloat(borderWidth / scale)
        let rect = CGRect(origin: CGPointZero, size: size)

        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, lineWidth)

        color.setFill()
        CGContextFillRect(context, rect)

        borderColor.setStroke()
        CGContextStrokeRect(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let result = image {
            return result
        } else {
            return UIImage()
        }
    }
}
