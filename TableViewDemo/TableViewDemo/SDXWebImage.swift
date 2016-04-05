//
//  SDXWebImage.swift
//  TableViewDemo
//
//  Created by wangchaojs02 on 16/4/5.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation
import SDWebImage

class ImageResizer: NSObject, SDWebImageManagerDelegate {
    static let standard = ImageResizer()
    var value = 5
    @objc func imageManager(imageManager: SDWebImageManager!, transformDownloadedImage image: UIImage!, withURL imageURL: NSURL!) -> UIImage! {
        // SSLogInfo("\(components?.queryItems)")
        guard let canvasInfo = imageURL.canvasInfo else { return image }

        if let sizeValue = (canvasInfo["canvas_size"] as? NSValue) {
            let size = sizeValue.CGSizeValue()
            let width = size.width
            let height = size.height

            let modeValue = canvasInfo["content_mode"] as? Int ?? 0
            let mode = UIViewContentMode(rawValue: modeValue) ?? UIViewContentMode.ScaleToFill

            let canvasBounds = CGRect(x: 0, y: 0, width: width, height: height)
            let imageBounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            var scaledBounds = imageBounds
            switch mode {
            case .ScaleAspectFill:
                scaledBounds = imageBounds.aspectFill(forFrame: canvasBounds)
            case .ScaleAspectFit:
                scaledBounds = imageBounds.aspectFit(forFrame: canvasBounds)
            case .ScaleToFill:
                scaledBounds = canvasBounds
            default:
                scaledBounds = imageBounds
            }
            let widthRatio = imageBounds.width / scaledBounds.width
            let heightRatio = imageBounds.height / scaledBounds.height

            guard abs(widthRatio - 1.0) > 0.2 || abs(heightRatio - 1.0) > 0.2 else {
                return image
            }

            UIGraphicsBeginImageContextWithOptions(scaledBounds.size, false, 0)
            image.drawInRect(CGRect(origin: CGPointZero, size: scaledBounds.size))

            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            SSLogInfo("origin:\(image.size) now:\(scaledImage.size)")
            return scaledImage
        }

        return image
    }

    class func urlByAppendCanvasInfo(toURL url: NSURL?, imageView: UIImageView?) -> NSURL? {

        guard let existURL = url, let existImageView = imageView else {
            return url
        }

        let components = NSURLComponents(URL: existURL, resolvingAgainstBaseURL: true)
        var queryItems = components?.queryItems ?? [NSURLQueryItem]()
        queryItems.append(NSURLQueryItem(name: "canvas_size", value: "\(existImageView.bounds.width)x\(existImageView.bounds.height)"))
        queryItems.append(NSURLQueryItem(name: "content_mode", value: "\(existImageView.contentMode.rawValue)"))
        components?.queryItems = queryItems

        components?.URL?.canvasInfo = [
            "canvas_size": NSValue(CGSize: existImageView.bounds.size),
            "content_mode": existImageView.contentMode.rawValue]
        return components?.URL
    }
}

extension NSURL {
    private struct AssociatedKeys {
        static var canvasInfo = "nsh_DescriptiveName"
    }
    var canvasInfo: [String: AnyObject]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.canvasInfo) as? [String: AnyObject]
        }

        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self,
                    &AssociatedKeys.canvasInfo,
                    newValue as [String: AnyObject]?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}

extension UIImageView {
    var sdx_imageURL: NSURL {
        set {
            self.sdx_setImageWithURL(newValue)
        }
        get {
            return self.sd_imageURL()
        }
    }

    func attachViewInfo(toURL url: NSURL?) -> NSURL? {
        return ImageResizer.urlByAppendCanvasInfo(toURL: url, imageView: self)
    }

    public func sdx_setImageWithURL(url: NSURL!) {
        self.sd_setImageWithURL(
            self.attachViewInfo(toURL: url))
    }

    public func sdx_setImageWithURL(url: NSURL!, placeholderImage placeholder: UIImage!) {
        self.sd_setImageWithURL(
            self.attachViewInfo(toURL: url),
            placeholderImage: placeholder)
    }

    public func sdx_setImageWithURL(url: NSURL!, placeholderImage placeholder: UIImage!, options: SDWebImageOptions) {
        self.sd_setImageWithURL(
            self.attachViewInfo(toURL: url),
            placeholderImage: placeholder,
            options: options)
    }

    public func sdx_setImageWithURL(url: NSURL!, completed completedBlock: SDWebImageCompletionBlock!) {
        self.sd_setImageWithURL(
            self.attachViewInfo(toURL: url),
            completed: completedBlock)
    }

    public func sdx_setImageWithURL(url: NSURL!, placeholderImage placeholder: UIImage!, completed completedBlock: SDWebImageCompletionBlock!) {
        self.sd_setImageWithURL(
            self.attachViewInfo(toURL: url),
            placeholderImage: placeholder,
            completed: completedBlock)
    }

    public func sdx_setImageWithURL(url: NSURL!, placeholderImage placeholder: UIImage!, options: SDWebImageOptions, completed completedBlock: SDWebImageCompletionBlock!) {
        self.sd_setImageWithURL(
            self.attachViewInfo(toURL: url),
            placeholderImage: placeholder,
            options: options,
            completed: completedBlock)
    }

    public func sdx_setImageWithURL(url: NSURL!,
        placeholderImage placeholder: UIImage!,
        options: SDWebImageOptions,
        progress progressBlock: SDWebImageDownloaderProgressBlock!,
        completed completedBlock: SDWebImageCompletionBlock!) {
            self.sd_setImageWithURL(
                self.attachViewInfo(toURL: url),
                placeholderImage: placeholder,
                options: options,
                progress: progressBlock,
                completed: completedBlock)
        }

    public func sdx_setImageWithPreviousCachedImageWithURL(url: NSURL!, placeholderImage placeholder: UIImage!, options: SDWebImageOptions, progress progressBlock: SDWebImageDownloaderProgressBlock!, completed completedBlock: SDWebImageCompletionBlock!) {
        self.sd_setImageWithPreviousCachedImageWithURL(
            self.attachViewInfo(toURL: url),
            placeholderImage: placeholder,
            options: options,
            progress: progressBlock,
            completed: completedBlock)
    }
}
