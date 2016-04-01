//
//  FeedListCell.swift
//  TableViewDemo
//
//  Created by wangchaojs02 on 16/3/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import ImageIO
import SDWebImage

struct FeedViewModel {
    var title: String
    var summary: String
    var photo: NSURL
}

protocol SupportViewModel {
    var viewModel: Any? { set get }
}

class ImageResizer: NSObject, SDWebImageManagerDelegate {
    static let standard = ImageResizer()
    var value = 5
    @objc func imageManager(imageManager: SDWebImageManager!, transformDownloadedImage image: UIImage!, withURL imageURL: NSURL!) -> UIImage! {
        let components = NSURLComponents(URL: imageURL, resolvingAgainstBaseURL: true)
        // SSLogInfo("\(components?.queryItems)")
        var queryItemsMap = [String: String]()
        guard let queryItems = components?.queryItems else { return image }
        for queryItem in queryItems {
            queryItemsMap[queryItem.name] = queryItem.value
        }

        if let sizeString = queryItemsMap["canvas_size"] {
            let sizeComponents = sizeString.componentsSeparatedByString("x")
            guard sizeComponents.count == 2,
                let width = Double(sizeComponents[0]),
                let height = Double(sizeComponents[1]) else { return image }
            // let size = CGSize(width: width, height: height)
            let modeValue = Int(queryItemsMap["content_mode"] ?? "0") ?? 0
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

    class func urlByAppendImageViewInfo(toURL url: NSURL?, imageView: UIImageView?) -> NSURL? {

        guard let existURL = url, let existImageView = imageView else {
            return url
        }

        let components = NSURLComponents(URL: existURL, resolvingAgainstBaseURL: true)
        var queryItems = components?.queryItems ?? [NSURLQueryItem]()
        queryItems.append(NSURLQueryItem(name: "canvas_size", value: "\(existImageView.bounds.width)x\(existImageView.bounds.height)"))
        queryItems.append(NSURLQueryItem(name: "content_mode", value: "\(existImageView.contentMode.rawValue)"))
        components?.queryItems = queryItems
        return components?.URL
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
        return ImageResizer.urlByAppendImageViewInfo(toURL: url, imageView: self)
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
class FeedListCell: UITableViewCell, SupportViewModel {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    // MARK: - SupportViewModel
    var viewModel: Any? {
        didSet {
            guard let feedViewModel = viewModel as? FeedViewModel else { return }
            titleLabel.text = feedViewModel.title
            summaryLabel.text = feedViewModel.summary

            if self.fd_isTemplateLayoutCell {
                // head image not affect cell height so just return for better performance
                return
            }

            SDWebImageManager.sharedManager().delegate = ImageResizer.standard
            // ImageResizer.urlByAppendImageViewInfo(toURL: feedViewModel.photo, imageView: photoView)
            photoView.sdx_setImageWithURL(
                feedViewModel.photo,
                placeholderImage: nil,
                options: [.LowPriority, .RetryFailed, .RefreshCached]) { (image, error, cacheType, url) -> Void in
                    SSLogInfo("\(error ?? "success")")
                }
        }
    }
}

// MARK: - Table Cycle
extension FeedListCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - IBAction
extension FeedListCell {
    @IBAction func unlike(sender: AnyObject) {
    }
}
