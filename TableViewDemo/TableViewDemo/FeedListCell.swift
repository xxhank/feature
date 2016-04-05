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
    @IBOutlet weak var actionView: UIView!
    // MARK: Scroll Content View
    lazy var swipView: UIScrollView = {
        var scrollView = UIScrollView(frame: self.bounds)
        return scrollView
    }()

    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        swipView.addSubview(self.contentView)
        // swipView.alwaysBounceHorizontal = true
        swipView.showsHorizontalScrollIndicator = false
        swipView.showsVerticalScrollIndicator = false
        swipView.pagingEnabled = true
        swipView.translatesAutoresizingMaskIntoConstraints = true
        swipView.backgroundColor = UIColor.grayColor()
        self.contentView.backgroundColor = UIColor.whiteColor()

        self.addSubview(swipView)

        let child = swipView
        let parent = self
        let left = NSLayoutConstraint(item: child, attribute: .Left, relatedBy: .Equal, toItem: parent, attribute: .Left, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: child, attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: child, attribute: .Right, relatedBy: .Equal, toItem: parent, attribute: .Right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: child, attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1, constant: 0)
        parent.addConstraints([left, top, right, bottom])

        return self
    }

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
        placeActionView()
    }
    override func updateConstraints() {
        defer { super.updateConstraints() }
        if self.fd_isTemplateLayoutCell {
            return
        }
        updateActionViewConstraints()
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

// MARK: - Swip Cell
extension FeedListCell: UIScrollViewDelegate {
    func placeActionView() {
        var contentSize = self.bounds.size
        contentSize.width += actionView.bounds.width
        var frame = actionView.frame
        frame.origin.x = contentSize.width - frame.width
        actionView.frame = frame
        swipView.addSubview(actionView)
        swipView.delegate = self
        swipView.contentSize = contentSize
    }
    func updateActionViewConstraints() {
        let child = actionView
        let parent = swipView

        let left = NSLayoutConstraint(item: child, attribute: .Left, relatedBy: .Equal, toItem: parent, attribute: .Left, multiplier: 1, constant: self.bounds.width)
        let right = NSLayoutConstraint(item: child, attribute: .Right, relatedBy: .Equal, toItem: parent, attribute: .Right, multiplier: 1, constant: 0)

        let top = NSLayoutConstraint(item: child, attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: child, attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: child, attribute: .Height, relatedBy: .Equal, toItem: parent, attribute: .Height, multiplier: 1, constant: 0)
        parent.addConstraints([left, right, top, bottom, height])
    }
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let tableView = self.superview?.superview as? UITableView
        tableView?.scrollEnabled = scrollView.contentOffset.x == 0
    }
}
