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
