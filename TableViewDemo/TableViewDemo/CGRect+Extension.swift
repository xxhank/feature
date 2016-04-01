//
//  CGRect+Extension.swift
//  TableViewDemo
//
//  Created by wangchaojs02 on 16/4/1.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation
import CoreGraphics // - CGGeometry.h
import AVFoundation

extension CGRect {
    enum Flags : CGFloat { case Unset = 123456789 }
    var left: CGFloat { return self.origin.x }
    var top: CGFloat { return self.origin.y }
    var right: CGFloat { return self.maxX }
    var bottom: CGFloat { return self.maxY }

    mutating func moveTo(x x: CGFloat = Flags.Unset.rawValue, y: CGFloat = Flags.Unset.rawValue) -> CGRect {
        if x != Flags.Unset.rawValue { self.origin.x = x }
        if y != Flags.Unset.rawValue { self.origin.y = y }
        return self
    }

    mutating func adjust(width width: CGFloat = 0, height: CGFloat = 0) -> CGRect { self.size.width += width
        self.size.height += height
        return self
    }
    mutating func adjustTo(width width: CGFloat = 0, height: CGFloat = Flags.Unset.rawValue) -> CGRect { self.size.width = width
        self.size.height = height
        return self
    }

    mutating func lead(left frame: CGRect, spacing: CGFloat = 0) -> CGRect {
        return moveTo(x: frame.left - spacing - self.width)
    }
    mutating func lead(top frame: CGRect, spacing: CGFloat = 0) -> CGRect {
        return moveTo(y: frame.top - spacing - self.height)
    }
    mutating func align(left frame: CGRect, spacing: CGFloat = 0) -> CGRect {
        return moveTo(x: frame.left + spacing)
    }
    mutating func align(right frame: CGRect, spacing: CGFloat = 0) -> CGRect {
        return moveTo(x: frame.right + spacing - self.width) }
    mutating func align(top frame: CGRect, spacing: CGFloat = 0) -> CGRect {
        return moveTo(y: frame.top + spacing)
    }
    mutating func align(bottom frame: CGRect, spacing: CGFloat = 0) -> CGRect { return moveTo(y: frame.bottom + spacing - self.height)
    }

    mutating func pin(right frame: CGRect, spacing: CGFloat = 0) -> CGRect {
        return moveTo(x: frame.right + spacing)
    }

    mutating func follow(right frame: CGRect, spacing: CGFloat = 0) -> CGRect {
        return moveTo(x: frame.right + spacing)
    }

    mutating func follow(bottom frame: CGRect, spacing: CGFloat = 0) -> CGRect {
        return moveTo(y: frame.bottom + spacing)
    }

    func aspectFit(forFrame to: CGRect) -> CGRect {
        let from = self
        let widthRatio = to.width / from.width
        let heightRatio = to.height / from.height

        let resizeRatio = min(widthRatio, heightRatio) // Aspect Fit

        let newHeight = from.height * resizeRatio
        let newWidth = from.width * resizeRatio

        return CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
    }

    func aspectFill(forFrame to: CGRect) -> CGRect {
        let from = self
        let widthRatio = to.width / from.width
        let heightRatio = to.height / from.height

        let resizeRatio = max(widthRatio, heightRatio) ; // Aspect Fill

        let newHeight = from.height * resizeRatio
        let newWidth = from.width * resizeRatio

        // AVMakeRectWithAspectRatioInsideRect(<#T##aspectRatio: CGSize##CGSize#>, <#T##boundingRect: CGRect##CGRect#>)

        return CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
    }
}