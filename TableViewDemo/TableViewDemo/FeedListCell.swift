//
//  FeedListCell.swift
//  TableViewDemo
//
//  Created by wangchaojs02 on 16/3/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
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
        SSLogInfo("\(components?.queryItems)")
    
        return image
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

            SDWebImageManager.sharedManager().delegate = ImageResizer.standard
            // let options =
            let components = NSURLComponents(URL: feedViewModel.photo, resolvingAgainstBaseURL: true)
            var queryItems = components?.queryItems ?? [NSURLQueryItem]()
            queryItems.append(NSURLQueryItem(name: "canvas_size", value: "\(self.photoView.bounds.width)x\(self.photoView.bounds.height)"))
            queryItems.append(NSURLQueryItem(name: "content_mode", value: "\(self.photoView.contentMode.rawValue)"))
            components?.queryItems = queryItems
            let url = components?.URL
            photoView.sd_setImageWithURL(url, placeholderImage: nil,
                options: [.LowPriority, .RetryFailed, .ProgressiveDownload, .RefreshCached]) { (image, error, cacheType, url) -> Void in
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
